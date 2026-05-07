import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iskai/helpers/showExitDialog.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/statistics.dart';
import 'package:iskai/models/words.dart';
import 'package:iskai/services/databaseService.dart';

class ComparisonMinigame extends StatefulWidget {
  final int selectedFolderId;
  const ComparisonMinigame({super.key, required this.selectedFolderId});

  @override
  State<ComparisonMinigame> createState() => _ComparisonMinigameState();
}

class _ComparisonMinigameState extends State<ComparisonMinigame> {
  DatabaseService _dbService = new DatabaseService();
  bool _isLoading = true;
  int page = 1;
  List<Words>? pageCards;
  List<Words> userWords = [];
  String? _selectedRightWord;
  String? _selectedLeftWord;
  List<String> leftColumn = [];
  List<String> rightColumn = [];
  String? _wrongLeft;
  String? _wrongRight;
  int amountCorrectAnswers = 0,
      amountIncorrectAnswers = 0,
      amountAnswersPerDay = 0;

  Future<bool> getWords() async {
    try {
      setState(() {
        _isLoading = true;
      });
      userWords!.clear();
      pageCards = await _dbService.getFlashcards(
        widget.selectedFolderId,
        page: page,
        limit: 6,
      );
      if (pageCards == null || pageCards!.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return false;
      }
      ;

      userWords.addAll(pageCards!);
      userWords.shuffle();
      page++;

      userWords.shuffle(Random());
      leftColumn = userWords.map((el) => el.word).toList();
      rightColumn = userWords.map((el) => el.translate).toList();
      leftColumn.shuffle(Random());
      rightColumn.shuffle(Random());

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Ошибка в получении слов: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        return true;
      }
      return false;
    }
  }

  void selectWord(String word) {
    setState(() {
      _selectedLeftWord = word;
    });
    _checkMatch();
  }

  Future<void> checkWords() async {
    if (leftColumn.isEmpty || rightColumn.isEmpty) {
      bool isWords = await getWords();
      if (!isWords) {
        print('Слова закончились');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.wordAreOver)),
        );
      }
      return;
    }
  }

  void selectTranslate(String word) {
    setState(() {
      _selectedRightWord = word;
    });
    _checkMatch();
  }

  void _checkMatch() async {
    if (_selectedLeftWord == null ||
        _selectedRightWord == null ||
        userWords!.isEmpty) {
      return;
    }

    final wordObject = userWords!.firstWhere(
      (el) => el.word == _selectedLeftWord,
    );
    if (wordObject.translate == _selectedRightWord) {
      print('Слово совпало с переводом');
      setState(() {
        leftColumn.remove(_selectedLeftWord);
        rightColumn.remove(_selectedRightWord);

        _selectedLeftWord = null;
        _selectedRightWord = null;

        amountAnswersPerDay++;
        amountCorrectAnswers++;
      });
    } else {
      print('Слово с переводом не совпало');
      setState(() {
        _wrongLeft = _selectedLeftWord;
        _wrongRight = _selectedRightWord;

        amountAnswersPerDay++;
        amountIncorrectAnswers++;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _wrongLeft = null;
          _wrongRight = null;
          _selectedLeftWord = null;
          _selectedRightWord = null;
        });
      });
    }
    await checkWords();
  }

  @override
  void initState() {
    super.initState();
    getWords();
  }

  Future<void> _handleBackPress() async {
    if (amountAnswersPerDay == 0) {
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
                  amountCorrectAnswers: amountCorrectAnswers,
                  amountIncorrectAnswers: amountIncorrectAnswers,
                  amountAnswersPerDay: amountAnswersPerDay,
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
      child: 
    Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.comparisonMinigameTitle),
        leading: IconButton(
          onPressed: _handleBackPress,
          icon: Icon(Icons.close),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: !_isLoading
                ? pageCards != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: leftColumn.map((word) {
                                    return GestureDetector(
                                      child: SizedBox(
                                        height: 60,
                                        width: 180,
                                        child: Card(
                                          color: _wrongLeft == word
                                              ? Colors.red.shade300
                                              : _selectedLeftWord == word
                                              ? Colors.blue.shade100
                                              : Theme.of(context).brightness ==
                                                    Brightness.dark
                                              ? Colors.grey
                                              : Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 24,
                                            ),
                                            child: Text(
                                              word,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () => selectWord(word),
                                    );
                                  }).toList(),
                                ),
                                Column(
                                  children: rightColumn.map((word) {
                                    return GestureDetector(
                                      child: SizedBox(
                                        height: 60,
                                        width: 180,
                                        child: Card(
                                          color: _wrongRight == word
                                              ? Colors.red.shade300
                                              : _selectedRightWord == word
                                              ? Colors.blue.shade100
                                              : Theme.of(context).brightness ==
                                                    Brightness.dark
                                              ? Colors.grey
                                              : Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 24,
                                            ),
                                            child: Text(
                                              word,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () => selectTranslate(word),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.statisticsPage,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.totalWords} $amountAnswersPerDay',
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.countOfcorrectWords} $amountCorrectAnswers',
                                      style: TextStyle(
                                        color: Colors.green[400],
                                      ),
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.countOfMistakes} $amountIncorrectAnswers',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                : CircularProgressIndicator(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Text(
              AppLocalizations.of(context)!.comparisonPositionTitle,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ));
  }
}
