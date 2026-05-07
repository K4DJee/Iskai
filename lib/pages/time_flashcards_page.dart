import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iskai/helpers/formatDuration.dart';
import 'package:iskai/helpers/showExitDialog.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/statistics.dart';
import 'package:iskai/models/words.dart';
import 'package:iskai/providers/words_actions_provider.dart';
import 'package:iskai/services/databaseService.dart';
import 'package:iskai/widgets/timeProgressBar.dart';
import 'package:provider/provider.dart';

class TimeFlashcardsPage extends StatefulWidget {
  final int selectedFolderId;
  const TimeFlashcardsPage({super.key, required this.selectedFolderId});

  @override
  State<TimeFlashcardsPage> createState() => _TimeFlashcardsPageState();
}

class _TimeFlashcardsPageState extends State<TimeFlashcardsPage> {
  Words? _currentFlashcard;
  bool _showAnswer = false;
  bool _isLoading = true;
  String? _selectedDifficulty;
  int? newCounter;
  Duration _selectedDuration = Duration(minutes: 1);
  List<Words> allFlashcards = [];
  List<Words>? pageFlashcards;
  int index = 0;
  int page = 1;
  late TextEditingController controller;
  final DatabaseService _dbService = DatabaseService();
  bool _isTimerStarted = false;
  bool _isTimerFinished = false;
  int correctWordsPerTime = 0,
      amountCorrectAnswers = 0,
      amountIncorrectAnswers = 0,
      amountAnswersPerDay = 0,
      wordsLearnedToday = 0;
  DateTime? _startTime;
  int hintAttempts = 0;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void setTimerAndStart(Duration timer) async {
    await _getFlashcards();
    print('Таймер пошёл');
    setState(() {
      _isTimerStarted = true;
      _selectedDuration = timer;
      _startTime = DateTime.now();
    });
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
          allFlashcards.shuffle();
          page++;
        }
      } while (pageFlashcards != null && pageFlashcards!.isNotEmpty);

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка загрузки слова: $e')));
      }
    }
  }

  Future<void> _nextFlashcard() async {
    try {
      print("${controller.text}, ${_currentFlashcard!.word}");
      if (_currentFlashcard != null &&
          controller.text.toLowerCase() !=
              _currentFlashcard!.word.toLowerCase()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.wrongWordTryAgain),
          ),
        );
        setState(() {
          amountIncorrectAnswers++;
          amountAnswersPerDay++;
        });
        return;
      }

      if (allFlashcards.length > index + 1) {
        setState(() {
          controller.clear();
          index++;
          _currentFlashcard = allFlashcards[index];
          _isLoading = false;
          _showAnswer = false;
          correctWordsPerTime++;
          wordsLearnedToday++;
          amountCorrectAnswers++;
          amountAnswersPerDay++;
        });
      } else {
        setState(() {
          controller.clear();
          index++;
          _currentFlashcard = null;
          _isLoading = false;
          _showAnswer = false;
        });

        _finishTimerEarly();
        return;
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.errSwitchingToTheNextTransl} $e',
            ),
          ),
        );
      }
    }
  }

  void _giveHint() {
    HapticFeedback.lightImpact();
    if (_currentFlashcard == null) return;

    if (hintAttempts >= 10) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Попыток не осталось"),
        ),
      );
      return;
    }

    final correctWord = _currentFlashcard!.word;
    final currentText = controller.text;

    int correctPrefixLength = 0;
    for (int i = 0; i < currentText.length && i < correctWord.length; i++) {
      if (currentText[i].toLowerCase() == correctWord[i].toLowerCase()) {
        correctPrefixLength++;
      } else {
        break;
      }
    }

    if (correctPrefixLength == correctWord.length) {
      _nextFlashcard();
    }

    int nextCharIndex;
    if (correctPrefixLength == 0) {
      nextCharIndex = 1;
    } else {
      nextCharIndex = correctPrefixLength + 1;
    }
    nextCharIndex = nextCharIndex.clamp(0, correctWord.length);
    final newHint = correctWord.substring(0, nextCharIndex);
    setState(() {
      controller.text = newHint;
      hintAttempts++;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text("Попыток осталось: ${10 - hintAttempts}"),
      ),
    );
    controller.selection = TextSelection.collapsed(offset: newHint.length);
  }

  Future<void> _finishTimerEarly() async{
    if (_isTimerStarted && !_isTimerFinished) {
      setState(() {
        _isTimerStarted = false;
        _isTimerFinished = true;
      });

      await _handleTimerFinish();
    }
    HapticFeedback.heavyImpact();
  }

  Future<void> _handleTimerFinish() async {
    if(!context.mounted) return;
    final actualDuration = _elapsedTime;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.trainingIsOver)),
    );

    await _dbService.createStatisticDay(
      widget.selectedFolderId,
      Statistics(
        folderId: widget.selectedFolderId,
        correctWordsPerTime: correctWordsPerTime,
        amountCorrectAnswers: amountCorrectAnswers,
        amountIncorrectAnswers: amountIncorrectAnswers,
        amountAnswersPerDay: amountAnswersPerDay,
        wordsLearnedToday: wordsLearnedToday,
        createdAt: DateTime.now().toString(),
      ),
    );
    if (!context.mounted) return;
    final player = AudioPlayer();
    await player.play(AssetSource('audio/timeFinishedSound.mp3'));
  }

  Duration get _elapsedTime {
    if (_startTime == null) return Duration.zero;
    return DateTime.now().difference(_startTime!);
  }

  Future<void> _handleBackPress() async {
    if (wordsLearnedToday == 0) {
      if (context.mounted) Navigator.pop(context);
      return;
    }

    final shouldExit = await showExitDialog(context);
    if (shouldExit == true && context.mounted) {
      HapticFeedback.heavyImpact();

      if (_isTimerStarted && !_isTimerFinished) {
        await _finishTimerEarly();
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
          title: Text(AppLocalizations.of(context)!.timePageTitle),
          elevation: 0,
          actions: [
            IconButton(
              icon: ImageIcon(AssetImage("assets/imgs/light_64px.png")),
              onPressed: () => _giveHint(),
            ),
          ],
          leading: IconButton(
            onPressed: _handleBackPress,
            icon: Icon(Icons.close),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if (_isTimerStarted)
                  TimerProgressBar(
                    testDuration: _selectedDuration,
                    onTimerFinish: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.trainingIsOver,
                          ),
                        ),
                      );
                      setState(() {
                        _isTimerStarted = false;
                        _isTimerFinished = true;
                      });
                      final actualDuration = _elapsedTime;
                      await _dbService.createStatisticDay(
                        widget.selectedFolderId,
                        Statistics(
                          folderId: widget.selectedFolderId,
                          correctWordsPerTime: correctWordsPerTime,
                          amountCorrectAnswers: amountCorrectAnswers,
                          amountIncorrectAnswers: amountIncorrectAnswers,
                          amountAnswersPerDay: amountAnswersPerDay,
                          wordsLearnedToday: wordsLearnedToday,
                          createdAt: DateTime.now().toString(),
                        ),
                      );
                      final player = AudioPlayer();
                      player.play((AssetSource('audio/timeFinishedSound.mp3')));
                      HapticFeedback.heavyImpact();
                    },
                  ),
                Expanded(
                  child: Center(
                    child: _isLoading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.selectTimeForWorkout,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        setTimerAndStart(Duration(minutes: 2)),
                                    child: Text(
                                      '2 ${AppLocalizations.of(context)!.minutes}',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        setTimerAndStart(Duration(minutes: 5)),
                                    child: Text(
                                      '5 ${AppLocalizations.of(context)!.minutes}',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        setTimerAndStart(Duration(minutes: 10)),
                                    child: Text(
                                      '10 ${AppLocalizations.of(context)!.minutes}',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        setTimerAndStart(Duration(minutes: 15)),
                                    child: Text(
                                      '15 ${AppLocalizations.of(context)!.minutes}',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        setTimerAndStart(Duration(minutes: 20)),
                                    child: Text(
                                      '20 ${AppLocalizations.of(context)!.minutes}',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        setTimerAndStart(Duration(minutes: 30)),
                                    child: Text(
                                      '30 ${AppLocalizations.of(context)!.minutes}',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(
                            width: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _currentFlashcard == null &&
                                        _isTimerFinished == false
                                    ? Column(
                                        children: [
                                          const Icon(
                                            Icons.warning,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.noWords,
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
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: _isTimerFinished == false
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _currentFlashcard!
                                                        .translate,
                                                    style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 40),
                                                  TextField(
                                                    controller: controller,
                                                    decoration: InputDecoration(
                                                      labelText: 'Слово',
                                                      suffixIcon: IconButton(
                                                        onPressed:
                                                            _nextFlashcard,
                                                        icon: const Icon(
                                                          Icons
                                                              .arrow_right_alt_sharp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/gifs/clock(60fps).gif',
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                  Card(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        16,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                              context,
                                                            )!.timeIsUp,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${AppLocalizations.of(context)!.totalWords} $amountAnswersPerDay',
                                                          ),
                                                          Text(
                                                            '${AppLocalizations.of(context)!.countOfcorrectWords} $amountCorrectAnswers',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green[400],
                                                            ),
                                                          ),
                                                          Text(
                                                            '${AppLocalizations.of(context)!.countOfMistakes} $amountIncorrectAnswers',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${AppLocalizations.of(context)!.countOfTime} ${formatDuration(_elapsedTime)}',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
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
