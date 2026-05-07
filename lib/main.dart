import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/helpers/fetch_urls.dart';
import 'package:iskai/helpers/themes.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/modals/AddWordModal.dart';
import 'package:iskai/models/achivement_update_result.dart';
import 'package:iskai/models/folders.dart';
import 'package:iskai/models/streak_update_result.dart';
import 'package:iskai/models/user_statistics.dart';
import 'package:iskai/models/words.dart';
import 'package:iskai/pages/statistic_page.dart';
import 'package:iskai/pages/achievements_page.dart';
import 'package:iskai/pages/flashcards_page.dart';
import 'package:iskai/pages/minigames_page.dart';
import 'package:iskai/pages/onboarding_screen.dart';
import 'package:iskai/pages/word_actions_page.dart';
import 'package:iskai/pages/word_sets_page.dart';
import 'package:iskai/providers/FolderUpdateProvider.dart';
import 'package:iskai/providers/words_actions_provider.dart';
import 'package:iskai/providers/words_provider.dart';
import 'package:iskai/services/modal_service.dart';
import 'package:iskai/services/notification_service.dart';
import 'package:iskai/services/overlay_service.dart';
import 'package:iskai/services/adService.dart';
import 'package:iskai/services/databaseService.dart';
import 'package:iskai/widgets/achievement_popup.dart';
import 'package:iskai/widgets/streak_popup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'pages/settings_page.dart';
import 'pages/sync_page.dart';
import 'modals/AddFolderModal.dart';
import 'package:provider/provider.dart';
import 'package:iskai/providers/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animations/animations.dart';
import 'package:iskai/helpers/achievement_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //async в main
  final prefs = await SharedPreferences.getInstance();
  bool onboardingShown = prefs.getBool('onboardingShown') ?? false;
  final dbService = DatabaseService();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => FolderUpdateProvider()),
        ChangeNotifierProvider(create: (_) => WordsProvider(dbService)),
        ChangeNotifierProvider(create: (_) => WordsActionsProvider()),
      ],
      child: MyApp(onboardingShown: onboardingShown),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onboardingShown;
  const MyApp({super.key, required this.onboardingShown});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      builder: (context, localeProvider, themeProvider, child) {
        return MaterialApp(
          title: 'Iskai',
          theme: themeProvider.currentTheme,
          darkTheme: themeProvider.currentTheme,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeProvider.locale,
          navigatorKey: navigatorKey,
          home: onboardingShown
              ? const MyHomePage(title: 'Iskai')
              : const OnBoardingScreen(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _folderNameController = TextEditingController();
  final _wordController = TextEditingController();
  final _translateController = TextEditingController();
  final _exampleController = TextEditingController();
  final overlayService = OverlayService();
  late TextEditingController searchController;
  List<Words> _filteredWords = [];
  final AdService _adService = AdService();
  final DatabaseService _dbService = DatabaseService();
  late WordsProvider provider;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    context.read<FolderUpdateProvider>().addListener(_onFolderUpdated);
    searchController.addListener((_onSearchChanged));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<WordsProvider>();
      await provider.init();
      _showStreakPopup(context);

      if (await NotificationService.shouldShowModal()) {
        ModalService.showImportantMessage(
          AppLocalizations.of(context)!.importantTitleInModal,
          AppLocalizations.of(context)!.rateUsDescInModal,
          [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.notNowBtnInModal),
            ),
            TextButton(
              onPressed: () async {
                await fetchUrl("https://www.rustore.ru/catalog/app/studio.k4dje.iskai", context);
              },
              child: Text(AppLocalizations.of(context)!.writeReviewBtnInModal),
            ),
          ],
        );
        await NotificationService.markShownModal();
      }
    });

    if (Platform.isWindows || Platform.isLinux) {
      return;
    }
    MobileAds.initialize().then((_) {
      if (mounted) {
        _adService.loadAd(context, setState);
      }
    });
  } 

  void _onSearchChanged() {
    final q = searchController.text;
    context.read<WordsProvider>().setSearchQuery(q);
  }

  void _onFolderUpdated() async {
    await provider.loadFolders();
    await provider.selectFolder(provider.selectedFolderId);
  }

  void _showAddFolderDialog(BuildContext context) {
    print('Открытие AddFolderDialog');
    _folderNameController.clear();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      builder: (context) => AddFolderModal(
        controller: _folderNameController,
        onCreate: () async {
          String folderName = _folderNameController.text.trim();
          if (folderName.isEmpty) return;
          if (folderName.isNotEmpty) {
            print('Имя папки: $folderName');
            try {
              await context.read<WordsProvider>().addFolderAndSelect(
                folderName,
              );
            } catch (e) {
              print('Ошибка при создании папки: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка создания папки: $e')),
              );
            }
          } else {
            print('Имя папки пустое');
          }
        },
      ),
    );
  }

  void _showAddWordDialog(BuildContext context) {
    print('Открытие AddWordDialog');
    if(!_checkFolderSelected(context)) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddWordModal(
        controller1: _wordController,
        controller2: _translateController,
        controller3: _exampleController,
        folders: provider.folders
            .map((folder) => {'id': folder.id, 'name': folder.name})
            .toList(),
        onFolderSelected: (id) {
          provider.selectFolder(id);
          print('Выбрана папка с ID: $id');
        },
        selectedFolderId: provider.selectedFolderId,
        onCreate: _addWord,
      ),
    );
  }

  Future<void> _addWord() async {
    final newWord = Words(
      folderId: provider.selectedFolderId,
      word: _wordController.text,
      translate: _translateController.text,
      example: _exampleController.text,
    );

    await provider.addWord(newWord);
  }

  void _showStreakPopup(BuildContext context) async {
    final parentContext = context;
    final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    StreakUpdateResult result = await _dbService.createUserStatistics(
      UserStatistics(dailyStreak: 1, createdAt: formatted),
    );
    AchievementUpdateResult achivementResult = await _dbService
        .updateProcessOfStreakInAchivement([6, 7, 8], result.streak);
    if (result.streak == 0) {
      return;
    }
    if (!achivementResult.success) {
      ScaffoldMessenger.of(
        parentContext,
      ).showSnackBar(SnackBar(content: Text('Ошибка с работой ударной серии')));
      return;
    } else if (achivementResult.success && achivementResult.unlocked) {
      if (result.streak == 0) {
        return;
      } else if (result.streak == 5) {
        Future.delayed(Duration(seconds: 2), () {
          _showAchievementPopup(
            context,
            AppLocalizations.of(context)!.achievementName6,
          );
        });
      } else if (result.streak == 50) {
        Future.delayed(Duration(seconds: 2), () {
          _showAchievementPopup(
            context,
            AppLocalizations.of(context)!.achievementName7,
          );
        });
      } else if (result.streak == 100) {
        Future.delayed(Duration(seconds: 2), () {
          _showAchievementPopup(
            context,
            AppLocalizations.of(context)!.achievementName8,
          );
        });
      } else {
        return;
      }
    }
    showDialog(
      context: parentContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        Future.delayed(Duration(seconds: 3), () {
          if (Navigator.of(parentContext).canPop()) {
            Navigator.of(parentContext).pop();
          }
        });
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(dialogContext).pop();
          },
          child: Center(child: StreakPopup(streak: result.streak)),
        );
      },
    );
  }

  void _showAchievementPopup(BuildContext context, String achievemntName) {
    showAchievementPopup(context, achievemntName);
  }

  bool _checkFolderSelected(BuildContext context){
    if (provider.selectedFolderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.selectFolder,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1)
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    provider = context.watch<WordsProvider>();
    final List<DropdownMenuItem<Folders>> items = provider.folders.take(10).map(
      (Folders folder) {
        return DropdownMenuItem<Folders>(
          value: folder,
          child: Text(folder.name),
        );
      },
    ).toList();

    return Scaffold(
      drawer: Drawer(
        child: Consumer<WordsProvider>(
          builder: (context, provider, child) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: ColorScheme.fromSeed(
                      seedColor: const Color.fromARGB(255, 77, 183, 58),
                    ).primary,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        child: Image.asset('assets/imgs/app_icon2.png'),
                      ),

                      Text(
                        '${AppLocalizations.of(context)!.selectedFolderTitle} ${provider.selectedFolder?.name ?? AppLocalizations.of(context)!.folderAbsent}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.wordsInFolder} ${provider.words.length}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                DropdownButton<int?>(
                  items: provider.folders.take(10).map((folder) {
                    return DropdownMenuItem<int?>(
                      value: folder.id,
                      child: Text(folder.name),
                    );
                  }).toList(),
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  hint: Text(AppLocalizations.of(context)!.yourFolders),
                  value: provider.selectedFolderId,
                  onChanged: (int? newValue) {
                    context.read<WordsProvider>().selectFolder(newValue);
                  },
                ),
                listTiles(context, provider, _showAddFolderDialog, ()=>_checkFolderSelected(context)),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (!_checkFolderSelected(context)) return;
              FocusScope.of(context).unfocus();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MinigamesPage(
                    selectedFolderId: provider.selectedFolderId!,
                  ),
                ),
              );
            },
            icon: ImageIcon(AssetImage("assets/imgs/game.png")),
          ),
          PopupMenuButton(
            tooltip: AppLocalizations.of(context)!.wordSetsTooltip,
            icon: ImageIcon(AssetImage('assets/imgs/addWordSets.png')),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: () {
                  if (provider.selectedFolderId != null) {
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordSetsPage(
                          selectedFolderId: provider.selectedFolderId!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.createFolder,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    ImageIcon(AssetImage('assets/imgs/addWordSets.png')),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.wordSetsPage),
                  ],
                ),
              ),
            ],
          ),
        ],
        title: Text(widget.title),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${AppLocalizations.of(context)!.selectedFolderTitle} ${provider.selectedFolder?.name ?? AppLocalizations.of(context)!.folderAbsent}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: SearchBar(
                            autoFocus: false,
                            constraints: BoxConstraints.tightFor(height: 40),
                            controller: searchController, //
                            trailing: <Widget>[const Icon(Icons.search)],
                            hintText: AppLocalizations.of(context)!.searchWords,
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: provider.filteredWords.isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.noWordsFound,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: provider.filteredWords.length,
                            itemBuilder: (context, index) {
                              final word = provider.filteredWords[index];

                              return OpenContainer(
                                closedColor: Theme.of(context).cardColor,
                                openColor: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                transitionType: ContainerTransitionType.fade,
                                transitionDuration: Duration(milliseconds: 10),
                                openBuilder: (context, action) {
                                  return WordActionsPage(
                                    word: word,
                                    onSave: (updatedWord) async {
                                      await context
                                          .read<WordsProvider>()
                                          .updateWord(updatedWord);
                                    },
                                    onDelete: (wordId) async {
                                      await context
                                          .read<WordsProvider>()
                                          .deleteWord(wordId);
                                    },
                                  );
                                },
                                closedBuilder: (context, action) {
                                  return Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: BorderSide.none,
                                    ),
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            word.word,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          subtitle: Text(
                                            word.translate,
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            bottom: 8,
                                          ),
                                          child: Text(word.example),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _adService.getAdWidget(),
                  ),
                  // Align(
                  //   alignment: Alignment(1.0, -0.4),
                  //   child: SafeArea(
                  //     child: Container(
                  //     width: double.infinity,
                  //     height: 60,
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: [
                  //           const Color(0xFF4DB74A),
                  //           const Color(0xFF77B73A),
                  //         ],
                  //         begin: Alignment.topLeft,
                  //         end: Alignment.bottomRight,
                  //       ),
                  //       borderRadius: const BorderRadius.vertical(
                  //         top: Radius.circular(20),
                  //       ),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.1),
                  //           blurRadius: 10,
                  //           offset: const Offset(0, -2),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Material(
                  //       color: Colors.transparent,
                  //       child: InkWell(
                  //         borderRadius: const BorderRadius.vertical(
                  //           top: Radius.circular(20),
                  //         ),
                  //         onTap: () async{
                  //          await fetchUrl("https://yoomoney.ru/to/4100119234375386", context);
                  //         },
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(12.0),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               const Icon(
                  //                 Icons.favorite,
                  //                 color: Colors.white,
                  //                 size: 24,
                  //               ),
                  //               const SizedBox(width: 8),
                  //                Text(
                  //                 AppLocalizations.of(context)!.supportUs,
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 8),
                  //               const Icon(
                  //                 Icons.arrow_forward_ios,
                  //                 color: Colors.white,
                  //                 size: 16,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  //   )
                  // ),
                ],
              ),
            ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addFolder',
            onPressed: () => _showAddFolderDialog(context),
            tooltip: AppLocalizations.of(context)!.addFolderTooltip,
            child: const Icon(Icons.folder),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'addWord',
            onPressed: () => _showAddWordDialog(context),
            tooltip: AppLocalizations.of(context)!.addWordTooltip,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    // _adService.dispose();
    super.dispose();
  }
}

Widget listTiles(
  BuildContext context,
  WordsProvider provider,
  Function _showAddFolderDialog,
  bool Function() isFolderSelected,
) {
  return Column(
    children: [
      ListTile(
        leading: const Icon(Icons.folder),
        title: Text(AppLocalizations.of(context)!.addFolderTooltip),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
          _showAddFolderDialog(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: Text(AppLocalizations.of(context)!.mainPage),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.sync),
        title: Text(AppLocalizations.of(context)!.synchronizationPage),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SyncPage()),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.analytics_outlined),
        title: Text(AppLocalizations.of(context)!.statisticsPage),
        onTap: () {
          if(!isFolderSelected()){
            Navigator.pop(context);
            return;
          }
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StatisticsPage(selectedFolderId: provider.selectedFolderId!),
            ),
          );
        },
      ),
      ListTile(
        leading: ImageIcon(
          // AssetImage("assets/imgs/cards-svgrepo-com.png"),
          AssetImage("assets/imgs/anki.png"),
        ),
        title: Text(AppLocalizations.of(context)!.educationAnki),
        onTap: () {
          if(!isFolderSelected()){
            Navigator.pop(context);
            return;
          }
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FlashcardPage(selectedFolderId: provider.selectedFolderId!),
            ),
          );
        },
      ),
      ListTile(
        leading: ImageIcon(AssetImage("assets/imgs/achievement-icon-1.png")),
        title: Text(AppLocalizations.of(context)!.achievementsPage),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AchievementsPage()),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: Text(AppLocalizations.of(context)!.settingsPage),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
      ),
    ],
  );
}
