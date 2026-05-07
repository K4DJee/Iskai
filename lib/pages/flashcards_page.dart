import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/helpers/achievement_overlay.dart';
import 'package:iskai/helpers/formatDayEnding.dart';
import 'package:iskai/helpers/showExitDialog.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/achievement.dart';
import 'package:iskai/models/achivement_update_result.dart';
import 'package:iskai/models/statistics.dart';
import 'package:iskai/models/words.dart';
import 'package:iskai/providers/words_actions_provider.dart';
import 'package:iskai/services/databaseService.dart';
import 'package:provider/provider.dart';

class FlashcardPage extends StatefulWidget {
  final int selectedFolderId;
  const FlashcardPage({super.key, required this.selectedFolderId});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  Words? _currentFlashcard;
  bool _showAnswer = false;
  bool _isLoading = true;
  String? _selectedDifficulty;
  int? newCounter;
  final DatabaseService _dbService = DatabaseService();
  int amountCorrectAnswers = 0,
      amountIncorrectAnswers = 0,
      amountAnswersPerDay = 0,
      wordsLearnedToday = 0;

  String showNextInDays(int days) {
    if (days == 1) {
      newCounter = 1;
    } else {
      newCounter = _currentFlashcard!.counter + days;
    }
    return '$newCounter ${formatDayEnding(days, context)}';
  }

  @override
  void initState() {
    super.initState();
    _loadFlashcard();
  }

  Future<void> _loadFlashcard() async {
    try {
      Words? flashcard = await SQLiteDatabase.instance.getFlashcard(
        widget.selectedFolderId,
      );
      if (mounted) {
        setState(() {
          _currentFlashcard = flashcard;
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
            '${AppLocalizations.of(context)!.errorLoadingFlashcard} $e',
          ),
        ),
      );
    }
  }

  Future<void> _setDifficulty(difficulty) async {
    try {
      if (_currentFlashcard == null) {
        // print('Отсутствует flashcard');
        return;
      }
      final rowAffected = await SQLiteDatabase.instance.changeWordDifficulty(
        _currentFlashcard?.id,
        difficulty!,
      );
      if (rowAffected == 0) {
        // print('Слова не существует');
        return;
      }
      setState(() {
        amountCorrectAnswers++;
        amountAnswersPerDay++;
        wordsLearnedToday++;
      });
      // print(
      //   'Сложность слова ${_currentFlashcard?.word} была успешна изменена на ${difficulty}}',
      // );

      await _loadFlashcard();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> updateProccessOfAchievements(BuildContext context) async {
    //learning words
    AchievementUpdateResult achivementResult = await _dbService
        .updateProcessOfStreakInAchivement([4, 10, 9], wordsLearnedToday);
    if (wordsLearnedToday == 0) {
      return;
    }
    if (!achivementResult.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error with the daily streak')));
      return;
    } else if (achivementResult.success && achivementResult.unlocked) {
      Achievement? achInfo;
      if (achivementResult.achId != null) {
        achInfo = await _dbService.getAchivementInfo(achivementResult.achId!);
      } else {
        achInfo = await _dbService.getAchivementInfo(9);
      }
      print(achInfo?.progress);
      if (achInfo == null) {
        return;
      }

      if (achInfo.progress == 10) {
        _showAchievementPopup(
          context,
          AppLocalizations.of(context)!.achievementName4,
        );
      } else if (achInfo.progress == 100) {
        _showAchievementPopup(
          context,
          AppLocalizations.of(context)!.achievementName10,
        );
      } else if (achInfo.progress == 500) {
        _showAchievementPopup(
          context,
          AppLocalizations.of(context)!.achievementName9,
        );
      }
    } else {
      return;
    }
  }

  Future<void> updateProccessOfAchievement(BuildContext context) async {
    //ach3
    Achievement? ach = await _dbService.getAchivementInfo(3);
    print("ach: $ach");
    if (ach?.unlocked == false) {
      //Обновление достижения
      AchievementUpdateResult result = await _dbService
          .updateProcessOfAchievement(3, 1);
      if (result.success) {
        _showAchievementPopup(
          context,
          AppLocalizations.of(context)!.achievementName3,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorUpdAch),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
  }

  void _showAchievementPopup(BuildContext context, String achievemntName) {
    showAchievementPopup(context, achievemntName);
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
          amountCorrectAnswers: amountCorrectAnswers,
          amountIncorrectAnswers: amountIncorrectAnswers,
          amountAnswersPerDay: amountAnswersPerDay,
          wordsLearnedToday: wordsLearnedToday,
          createdAt: DateTime.now().toString(),
        ),
      );
      await updateProccessOfAchievements(context);
      print("wordsLearnedToday: $wordsLearnedToday");
      print("_currentFlashcard: $_currentFlashcard");
      if (_currentFlashcard == null && wordsLearnedToday != 0) {
        await updateProccessOfAchievement(context);
      }

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
          title: Text(AppLocalizations.of(context)!.educationAnki),
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async =>
                                                await _setDifficulty('hard'),
                                            child: Text(
                                              "${AppLocalizations.of(context)!.highDifficulty}\n ${showNextInDays(1)}",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async =>
                                                await _setDifficulty('medium'),
                                            child: Text(
                                              '${AppLocalizations.of(context)!.mediumDifficulty}\n${showNextInDays(2)}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async =>
                                                await _setDifficulty('easy'),
                                            child: Text(
                                              '${AppLocalizations.of(context)!.lowDifficulty}\n${showNextInDays(3)}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
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
