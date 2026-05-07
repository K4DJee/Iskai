import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iskai/helpers/formatDayEnding.dart';
import 'package:iskai/helpers/showExitDialog.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/statistics.dart';
import 'package:iskai/models/words.dart';
import 'package:iskai/providers/words_actions_provider.dart';
import 'package:iskai/services/databaseService.dart';
import 'package:provider/provider.dart';

class AllFlashcardsPage extends StatefulWidget {
  final int selectedFolderId;
  const AllFlashcardsPage({super.key, required this.selectedFolderId});

  @override
  State<AllFlashcardsPage> createState() => _AllFlashcardsPageState();
}

class _AllFlashcardsPageState extends State<AllFlashcardsPage> {
  Words? _currentFlashcard;
  bool _showAnswer = false;
  bool _isLoading = true;
  String? _selectedDifficulty;
  int? newCounter;
  final DatabaseService _dbService = DatabaseService();
  int page = 1;
  List<Words> allFlashcards = [];
  List<Words>? pageFlashcards;
  int index = 0;
  int wordsLearnedToday = 0;

  String showNextInDays(int days) {
    newCounter = _currentFlashcard!.counter + days;
    return '$newCounter ${formatDayEnding(days, context)}';
  }

  @override
  void initState() {
    super.initState();
    _getFlashcards();
  }

  Future<void> _getFlashcards() async {
    try {
      setState(() {
        _isLoading = true;
      });
      allFlashcards.clear();
      do {
        pageFlashcards = await _dbService.getFlashcards(
          widget.selectedFolderId,
          page: page,
          limit: 15,
        );
        if (pageFlashcards != null) {
          allFlashcards.addAll(pageFlashcards!);
          page++;
        }
      } while (pageFlashcards != null && pageFlashcards!.isNotEmpty);

      allFlashcards.shuffle(Random());

      if (mounted) {
        setState(() {
          _isLoading = false;
          _showAnswer = false;
          _currentFlashcard = allFlashcards.isNotEmpty
              ? allFlashcards[0]
              : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.errorLoadingFlashcards} $e',
          ),
        ),
      );
    }
  }

  Future<void> _nextFlashcard() async {
    try {
      if (allFlashcards.length > index + 1) {
        setState(() {
          index++;
          _currentFlashcard = allFlashcards[index];
          wordsLearnedToday++;
          _isLoading = false;
          _showAnswer = false;
        });
      } else {
        setState(() {
          index++;
          _currentFlashcard = null;
          _isLoading = false;
          _showAnswer = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.errorSwitchingToTheNextCard} $e',
          ),
        ),
      );
    }
  }

  Future<void> _handleBackPress() async {
    if (wordsLearnedToday == 0) {
      if (context.mounted) Navigator.pop(context);
      return;
    }

    final shouldExit = await showExitDialog(context);
    if (shouldExit == true && context.mounted) {
      HapticFeedback.heavyImpact();

      await _dbService.createStatisticDay(
        widget.selectedFolderId,
        Statistics(
          folderId: widget.selectedFolderId,
          wordsLearnedToday: wordsLearnedToday,
          createdAt: DateTime.now().toString(),
        ),
      );

     if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBackPress();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.allFlashcards),
          leading: IconButton(
            onPressed: _handleBackPress,
            icon: Icon(Icons.close),
          ),
        ),

        body: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 350,
                height: 400,
                child: Card(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.green,
                            valueColor: AlwaysStoppedAnimation(Colors.black26),
                          ),
                        )
                      : (_currentFlashcard == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      AppLocalizations.of(context)!.noWords,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.noWordsDescription,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (_currentFlashcard == null)
                                    Text(
                                      AppLocalizations.of(context)!.noMoreWords,
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${AppLocalizations.of(context)!.wordInFlashcard} ${_currentFlashcard?.word ?? '...'}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (_showAnswer)
                                            Text(
                                              '${AppLocalizations.of(context)!.translateInFlashcard} ${_currentFlashcard?.translate}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                  if (_showAnswer)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 16.0,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () async =>
                                            await _nextFlashcard(),
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.nextWord,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 16.0,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() => _showAnswer = true);
                                        },
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.showAnswer,
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                ),
              ),
            ),
            if (wordsLearnedToday != 0)
              Positioned(
                left: 25,
                right: 0,
                bottom: 50,
                child: Text(
                  "${AppLocalizations.of(context)!.wordsPassed} $wordsLearnedToday",
                  textAlign: TextAlign.left,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
