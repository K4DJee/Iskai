import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru')
  ];

  /// No description provided for @languageNameEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageNameEn;

  /// No description provided for @languageNameRu.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageNameRu;

  /// No description provided for @languageNameFr.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageNameFr;

  /// No description provided for @languageNameEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageNameEs;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Iskai'**
  String get appTitle;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @yourFolders.
  ///
  /// In en, this message translates to:
  /// **'Your folders'**
  String get yourFolders;

  /// No description provided for @mainPage.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mainPage;

  /// No description provided for @synchronizationPage.
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get synchronizationPage;

  /// No description provided for @statisticsPage.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsPage;

  /// No description provided for @educationAnki.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get educationAnki;

  /// No description provided for @settingsPage.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPage;

  /// No description provided for @showBottomSheetChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get showBottomSheetChange;

  /// No description provided for @addFolderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Folder'**
  String get addFolderTooltip;

  /// No description provided for @addWordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Word'**
  String get addWordTooltip;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @addWordButton.
  ///
  /// In en, this message translates to:
  /// **'Add word'**
  String get addWordButton;

  /// No description provided for @addWordModal.
  ///
  /// In en, this message translates to:
  /// **'Adding a word'**
  String get addWordModal;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get deleteConfirmation;

  /// No description provided for @wordInput.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get wordInput;

  /// No description provided for @translateInput.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateInput;

  /// No description provided for @exampleInput.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get exampleInput;

  /// No description provided for @createNewFolder.
  ///
  /// In en, this message translates to:
  /// **'Creating new folder'**
  String get createNewFolder;

  /// No description provided for @selectFolder.
  ///
  /// In en, this message translates to:
  /// **'Select a folder'**
  String get selectFolder;

  /// No description provided for @nameFolder.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get nameFolder;

  /// No description provided for @createFolderButton.
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get createFolderButton;

  /// No description provided for @folderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the folder name'**
  String get folderNameHint;

  /// No description provided for @wordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the word'**
  String get wordHint;

  /// No description provided for @translateHint.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateHint;

  /// No description provided for @exampleHint.
  ///
  /// In en, this message translates to:
  /// **'Example (optional)'**
  String get exampleHint;

  /// No description provided for @wordsInFolder.
  ///
  /// In en, this message translates to:
  /// **'Words: '**
  String get wordsInFolder;

  /// No description provided for @selectedFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Folder:'**
  String get selectedFolderTitle;

  /// No description provided for @folderAbsent.
  ///
  /// In en, this message translates to:
  /// **'no folder'**
  String get folderAbsent;

  /// No description provided for @wordActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing a word'**
  String get wordActionsTitle;

  /// No description provided for @localSync.
  ///
  /// In en, this message translates to:
  /// **'Local synchronization'**
  String get localSync;

  /// No description provided for @globalSync.
  ///
  /// In en, this message translates to:
  /// **'Global synchronization'**
  String get globalSync;

  /// No description provided for @supportUs.
  ///
  /// In en, this message translates to:
  /// **'Support us'**
  String get supportUs;

  /// No description provided for @createFolder.
  ///
  /// In en, this message translates to:
  /// **'Create a folder'**
  String get createFolder;

  /// No description provided for @errorSwitchingToTheNextCard.
  ///
  /// In en, this message translates to:
  /// **'Error switching to the next card:'**
  String get errorSwitchingToTheNextCard;

  /// No description provided for @folderModalError2.
  ///
  /// In en, this message translates to:
  /// **'Please enter the folder name.'**
  String get folderModalError2;

  /// No description provided for @folderModalError1.
  ///
  /// In en, this message translates to:
  /// **'the folder name cannot be empty!'**
  String get folderModalError1;

  /// No description provided for @dataSuccessfullyAccepted.
  ///
  /// In en, this message translates to:
  /// **'The data was successfully accepted!'**
  String get dataSuccessfullyAccepted;

  /// No description provided for @errorGettingIpStatus.
  ///
  /// In en, this message translates to:
  /// **'Error receiving the IP address'**
  String get errorGettingIpStatus;

  /// No description provided for @errorGettingIp.
  ///
  /// In en, this message translates to:
  /// **'Error receiving the IP. Check your Wifi connection'**
  String get errorGettingIp;

  /// No description provided for @countOfTime.
  ///
  /// In en, this message translates to:
  /// **'Time:'**
  String get countOfTime;

  /// No description provided for @countOfMistakes.
  ///
  /// In en, this message translates to:
  /// **'Mistakes:'**
  String get countOfMistakes;

  /// No description provided for @countOfcorrectWords.
  ///
  /// In en, this message translates to:
  /// **'Correctly::'**
  String get countOfcorrectWords;

  /// No description provided for @totalWords.
  ///
  /// In en, this message translates to:
  /// **'Total words:'**
  String get totalWords;

  /// No description provided for @timeIsUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up!'**
  String get timeIsUp;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @folderNamePage.
  ///
  /// In en, this message translates to:
  /// **'Changing the folder name'**
  String get folderNamePage;

  /// No description provided for @errorLoadingFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Error loading the flashcards:'**
  String get errorLoadingFlashcards;

  /// No description provided for @errorLoadingFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Error loading the flashcard:'**
  String get errorLoadingFlashcard;

  /// No description provided for @wordSetsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Go to Word sets'**
  String get wordSetsTooltip;

  /// No description provided for @amountOfWords.
  ///
  /// In en, this message translates to:
  /// **'Amount of words:'**
  String get amountOfWords;

  /// No description provided for @downloadSelectedWordsBtn.
  ///
  /// In en, this message translates to:
  /// **'Download selected files'**
  String get downloadSelectedWordsBtn;

  /// No description provided for @downloadAllWordsBtn.
  ///
  /// In en, this message translates to:
  /// **'Download all words'**
  String get downloadAllWordsBtn;

  /// No description provided for @errorAddingWords.
  ///
  /// In en, this message translates to:
  /// **'Error adding words:'**
  String get errorAddingWords;

  /// No description provided for @selectLang.
  ///
  /// In en, this message translates to:
  /// **'Select a language'**
  String get selectLang;

  /// No description provided for @successAddedWordsToFolders.
  ///
  /// In en, this message translates to:
  /// **'Words added to folder!'**
  String get successAddedWordsToFolders;

  /// No description provided for @notSelectedWordsForAdd.
  ///
  /// In en, this message translates to:
  /// **'There are no selected words'**
  String get notSelectedWordsForAdd;

  /// No description provided for @errorLoadJsonFromWordSet.
  ///
  /// In en, this message translates to:
  /// **'Error loading JSON:'**
  String get errorLoadJsonFromWordSet;

  /// No description provided for @wordSetsPage.
  ///
  /// In en, this message translates to:
  /// **'Set of words'**
  String get wordSetsPage;

  /// No description provided for @numbersSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numbersSetDescription;

  /// No description provided for @animalsSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Animal names'**
  String get animalsSetDescription;

  /// No description provided for @foodSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Food names'**
  String get foodSetDescription;

  /// No description provided for @educationSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Words related to education and learning.'**
  String get educationSetDescription;

  /// No description provided for @numbersSetName.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numbersSetName;

  /// No description provided for @animalsSetName.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get animalsSetName;

  /// No description provided for @foodSetName.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get foodSetName;

  /// No description provided for @educationSetName.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get educationSetName;

  /// No description provided for @minigamesPage.
  ///
  /// In en, this message translates to:
  /// **'Mini-games'**
  String get minigamesPage;

  /// No description provided for @achievementsPage.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsPage;

  /// No description provided for @achievementReceived.
  ///
  /// In en, this message translates to:
  /// **'Achievement received!'**
  String get achievementReceived;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyHeader.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy of the Iskai App'**
  String get privacyPolicyHeader;

  /// No description provided for @privacyPolicyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: November 13, 2025'**
  String get privacyPolicyLastUpdated;

  /// No description provided for @privacyPolicyWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Privacy Policy of the Iskai app (\"App\"). This policy explains how we collect, use, store, and protect your personal information when using the App. Iskai is developed by K4DJE Studio (developer: K4DJE, Dmitry Mishchenko) and is available on MacOS, Linux, Windows, Android, and iOS. We are committed to transparency and protecting your privacy.'**
  String get privacyPolicyWelcome;

  /// No description provided for @privacyPolicyAgreement.
  ///
  /// In en, this message translates to:
  /// **'By using the App, you agree to the terms of this policy. If you do not agree, please do not use the App.'**
  String get privacyPolicyAgreement;

  /// No description provided for @privacyPolicySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get privacyPolicySection1Title;

  /// No description provided for @privacyPolicySection1Description.
  ///
  /// In en, this message translates to:
  /// **'Iskai is designed to create dictionaries, organize words into folders, export and import data via JSON files, and synchronize data between devices. We minimize the collection of personal data and do not store it on our servers unless necessary.'**
  String get privacyPolicySection1Description;

  /// No description provided for @privacyPolicySection1_1Title.
  ///
  /// In en, this message translates to:
  /// **'1.1. Data Provided by the User'**
  String get privacyPolicySection1_1Title;

  /// No description provided for @privacyPolicySection1_1DictionaryContent.
  ///
  /// In en, this message translates to:
  /// **'- Dictionary content: Words, folders, and related data you enter in the App. This data is stored locally on your device.'**
  String get privacyPolicySection1_1DictionaryContent;

  /// No description provided for @privacyPolicySection1_1SyncData.
  ///
  /// In en, this message translates to:
  /// **'- Synchronization data: During local sync (via Wi-Fi within the same network) or global sync (via an intermediary server), only your dictionary data is transmitted. The server does not store these data; it acts solely as a temporary bridge between devices.'**
  String get privacyPolicySection1_1SyncData;

  /// No description provided for @privacyPolicySection1_2Title.
  ///
  /// In en, this message translates to:
  /// **'1.2. Automatically Collected Data'**
  String get privacyPolicySection1_2Title;

  /// No description provided for @privacyPolicySection1_2TechnicalInfo.
  ///
  /// In en, this message translates to:
  /// **'- Technical information: IP address, device type, OS version, and unique device ID (for synchronization and debugging purposes).'**
  String get privacyPolicySection1_2TechnicalInfo;

  /// No description provided for @privacyPolicySection1_2UsageData.
  ///
  /// In en, this message translates to:
  /// **'- Usage data: Information about how you interact with the App, such as feature usage frequency, used to improve the product (anonymized).'**
  String get privacyPolicySection1_2UsageData;

  /// No description provided for @privacyPolicySection1_2AdData.
  ///
  /// In en, this message translates to:
  /// **'- Advertising data: The App integrates ads via Yandex Ads. Yandex may collect data for ad personalization, including device identifiers, approximate location (based on IP), and in-app behavior. We do not have access to this data; it is processed by Yandex according to their Privacy Policy.'**
  String get privacyPolicySection1_2AdData;

  /// No description provided for @privacyPolicyNoSensitiveData.
  ///
  /// In en, this message translates to:
  /// **'We do not collect sensitive information such as biometric data, financial details, or health information.'**
  String get privacyPolicyNoSensitiveData;

  /// No description provided for @privacyPolicySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get privacyPolicySection2Title;

  /// No description provided for @privacyPolicySection2Services.
  ///
  /// In en, this message translates to:
  /// **'- To provide services: Storing and synchronizing your dictionary data between devices.'**
  String get privacyPolicySection2Services;

  /// No description provided for @privacyPolicySection2Improvement.
  ///
  /// In en, this message translates to:
  /// **'- To improve the App: Analyzing anonymized usage data to identify bugs and optimize features.'**
  String get privacyPolicySection2Improvement;

  /// No description provided for @privacyPolicySection2Ads.
  ///
  /// In en, this message translates to:
  /// **'- For advertising: Yandex Ads uses collected data to display relevant ads. We are not directly involved in this process.'**
  String get privacyPolicySection2Ads;

  /// No description provided for @privacyPolicySection2Legal.
  ///
  /// In en, this message translates to:
  /// **'- To comply with laws: When required to fulfill legal obligations, such as responding to requests from authorities.'**
  String get privacyPolicySection2Legal;

  /// No description provided for @privacyPolicyNoSellingData.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal data to third parties.'**
  String get privacyPolicyNoSellingData;

  /// No description provided for @privacyPolicySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Disclosure to Third Parties'**
  String get privacyPolicySection3Title;

  /// No description provided for @privacyPolicySection3YandexAds.
  ///
  /// In en, this message translates to:
  /// **'- Yandex Ads: To enable ads, we share minimal technical data (e.g., device identifiers) with Yandex. Details about Yandex’s data processing are available in their Privacy Policy: https://yandex.com/legal/confidential/.'**
  String get privacyPolicySection3YandexAds;

  /// No description provided for @privacyPolicySection3SyncServers.
  ///
  /// In en, this message translates to:
  /// **'- Sync servers: During global synchronization, data passes through our servers but is not stored. We may use cloud providers (e.g., AWS or similar) that comply with security standards.'**
  String get privacyPolicySection3SyncServers;

  /// No description provided for @privacyPolicySection3OtherCases.
  ///
  /// In en, this message translates to:
  /// **'- Other cases: We may disclose information if required by law, to protect our rights, or in case of a merger/acquisition of K4DJE Studio.'**
  String get privacyPolicySection3OtherCases;

  /// No description provided for @privacyPolicySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Data Storage and Security'**
  String get privacyPolicySection4Title;

  /// No description provided for @privacyPolicySection4LocalStorage.
  ///
  /// In en, this message translates to:
  /// **'- Local storage: Most data is stored on your device. We recommend using device encryption and passwords for protection.'**
  String get privacyPolicySection4LocalStorage;

  /// No description provided for @privacyPolicySection4Sync.
  ///
  /// In en, this message translates to:
  /// **'- Synchronization: Data is transmitted securely (via HTTPS). The server does not store data after transfer.'**
  String get privacyPolicySection4Sync;

  /// No description provided for @privacyPolicySection4Retention.
  ///
  /// In en, this message translates to:
  /// **'- Data retention: We do not store your data on servers. Local data is deleted when the App is uninstalled or upon your request.'**
  String get privacyPolicySection4Retention;

  /// No description provided for @privacyPolicySection4Security.
  ///
  /// In en, this message translates to:
  /// **'- Security measures: We apply standard protection measures such as encryption, firewalls, and regular audits to prevent unauthorized access. However, no system is completely secure, and we cannot guarantee absolute protection.'**
  String get privacyPolicySection4Security;

  /// No description provided for @privacyPolicySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Your Rights'**
  String get privacyPolicySection5Title;

  /// No description provided for @privacyPolicySection5RightsIntro.
  ///
  /// In en, this message translates to:
  /// **'Depending on your location (for example, under GDPR in the EU or the Russian Federal Law on Personal Data), you have the right to:'**
  String get privacyPolicySection5RightsIntro;

  /// No description provided for @privacyPolicySection5Access.
  ///
  /// In en, this message translates to:
  /// **'- Access your data.'**
  String get privacyPolicySection5Access;

  /// No description provided for @privacyPolicySection5Correction.
  ///
  /// In en, this message translates to:
  /// **'- Correct or update your data.'**
  String get privacyPolicySection5Correction;

  /// No description provided for @privacyPolicySection5Deletion.
  ///
  /// In en, this message translates to:
  /// **'- Delete your data (for example, via export and clearing within the App).'**
  String get privacyPolicySection5Deletion;

  /// No description provided for @privacyPolicySection5Complaint.
  ///
  /// In en, this message translates to:
  /// **'- File a complaint with a supervisory authority.'**
  String get privacyPolicySection5Complaint;

  /// No description provided for @privacyPolicySection7Title.
  ///
  /// In en, this message translates to:
  /// **'6. Changes to This Policy'**
  String get privacyPolicySection7Title;

  /// No description provided for @privacyPolicySection7Changes.
  ///
  /// In en, this message translates to:
  /// **'We may update this policy. Updates will be published in the App or on our website. Continuing to use the App after an update constitutes acceptance of the changes.'**
  String get privacyPolicySection7Changes;

  /// No description provided for @privacyPolicySection8Title.
  ///
  /// In en, this message translates to:
  /// **'7. Contact Us'**
  String get privacyPolicySection8Title;

  /// No description provided for @privacyPolicySection8Questions.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or requests, please contact us:'**
  String get privacyPolicySection8Questions;

  /// No description provided for @privacyPolicySection8Developer.
  ///
  /// In en, this message translates to:
  /// **'- Developer: Dmitry Mishchenko (K4DJE)'**
  String get privacyPolicySection8Developer;

  /// No description provided for @privacyPolicySection8Email.
  ///
  /// In en, this message translates to:
  /// **'- Email: k4djexfullstack@gmail.com'**
  String get privacyPolicySection8Email;

  /// No description provided for @privacyPolicySection8Studio.
  ///
  /// In en, this message translates to:
  /// **'- Studio: K4DJE Studio'**
  String get privacyPolicySection8Studio;

  /// No description provided for @privacyPolicyThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using Iskai! We appreciate your trust.'**
  String get privacyPolicyThanks;

  /// No description provided for @achievementName1.
  ///
  /// In en, this message translates to:
  /// **'First App Launch'**
  String get achievementName1;

  /// No description provided for @achievementDescription1.
  ///
  /// In en, this message translates to:
  /// **'First launch of the app. Welcome to the world of knowledge!'**
  String get achievementDescription1;

  /// No description provided for @achievementName2.
  ///
  /// In en, this message translates to:
  /// **'First Word'**
  String get achievementName2;

  /// No description provided for @achievementDescription2.
  ///
  /// In en, this message translates to:
  /// **'Add your first word to your dictionary.'**
  String get achievementDescription2;

  /// No description provided for @achievementName3.
  ///
  /// In en, this message translates to:
  /// **'I Want to Know Everything!'**
  String get achievementName3;

  /// No description provided for @achievementDescription3.
  ///
  /// In en, this message translates to:
  /// **'Study all the words for the day.'**
  String get achievementDescription3;

  /// No description provided for @achievementName4.
  ///
  /// In en, this message translates to:
  /// **'Novice Explorer'**
  String get achievementName4;

  /// No description provided for @achievementDescription4.
  ///
  /// In en, this message translates to:
  /// **'Learn 10 new words.'**
  String get achievementDescription4;

  /// No description provided for @achievementName5.
  ///
  /// In en, this message translates to:
  /// **'Connoisseur'**
  String get achievementName5;

  /// No description provided for @achievementDescription5.
  ///
  /// In en, this message translates to:
  /// **'Leave a review of our app and help it gain popularity.'**
  String get achievementDescription5;

  /// No description provided for @achievementName6.
  ///
  /// In en, this message translates to:
  /// **'Enthusiast'**
  String get achievementName6;

  /// No description provided for @achievementDescription6.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 5-day streak.'**
  String get achievementDescription6;

  /// No description provided for @achievementName7.
  ///
  /// In en, this message translates to:
  /// **'50 Days'**
  String get achievementName7;

  /// No description provided for @achievementDescription7.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 50-day streak.'**
  String get achievementDescription7;

  /// No description provided for @achievementName8.
  ///
  /// In en, this message translates to:
  /// **'Discipline Master'**
  String get achievementName8;

  /// No description provided for @achievementDescription8.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 100-day streak.'**
  String get achievementDescription8;

  /// No description provided for @achievementName9.
  ///
  /// In en, this message translates to:
  /// **'Sage'**
  String get achievementName9;

  /// No description provided for @achievementDescription9.
  ///
  /// In en, this message translates to:
  /// **'Learn 500 words.'**
  String get achievementDescription9;

  /// No description provided for @achievementName10.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get achievementName10;

  /// No description provided for @achievementDescription10.
  ///
  /// In en, this message translates to:
  /// **'Learn 125 words.'**
  String get achievementDescription10;

  /// No description provided for @achievementName11.
  ///
  /// In en, this message translates to:
  /// **'Social Guru'**
  String get achievementName11;

  /// No description provided for @achievementDescription11.
  ///
  /// In en, this message translates to:
  /// **'Share an achievement on social media.'**
  String get achievementDescription11;

  /// No description provided for @unlockedStatus.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlockedStatus;

  /// No description provided for @errorFetchUrl.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link'**
  String get errorFetchUrl;

  /// No description provided for @dbLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get dbLoading;

  /// No description provided for @dbSize.
  ///
  /// In en, this message translates to:
  /// **'Database size:'**
  String get dbSize;

  /// No description provided for @warningTitleInModal.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warningTitleInModal;

  /// No description provided for @deleteDbTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete the database'**
  String get deleteDbTitle;

  /// No description provided for @deleteDbDescInModal.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the database? All data will be permanently deleted.'**
  String get deleteDbDescInModal;

  /// No description provided for @doNotDeleteDbBtnInModal.
  ///
  /// In en, this message translates to:
  /// **'Do not delete'**
  String get doNotDeleteDbBtnInModal;

  /// No description provided for @deleteDbBtnInModal.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteDbBtnInModal;

  /// No description provided for @notNowBtnInModal.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNowBtnInModal;

  /// No description provided for @writeReviewBtnInModal.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get writeReviewBtnInModal;

  /// No description provided for @importantTitleInModal.
  ///
  /// In en, this message translates to:
  /// **'Important information'**
  String get importantTitleInModal;

  /// No description provided for @rateUsDescInModal.
  ///
  /// In en, this message translates to:
  /// **'Do you like Iskai? Please rate us in RuStore. Your support directly affects the frequency of updates.'**
  String get rateUsDescInModal;

  /// No description provided for @displayNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Displaying app notifications'**
  String get displayNotificationsTitle;

  /// No description provided for @interactionWithTheDB.
  ///
  /// In en, this message translates to:
  /// **'Interaction with the database'**
  String get interactionWithTheDB;

  /// No description provided for @wordsPassed.
  ///
  /// In en, this message translates to:
  /// **'Words passed:'**
  String get wordsPassed;

  /// No description provided for @streakTitle.
  ///
  /// In en, this message translates to:
  /// **'in a row'**
  String get streakTitle;

  /// No description provided for @comparisonMinigameTitle.
  ///
  /// In en, this message translates to:
  /// **'Word comparison and translation'**
  String get comparisonMinigameTitle;

  /// No description provided for @comparisonPositionTitle.
  ///
  /// In en, this message translates to:
  /// **'Match the word correctly with its translation.'**
  String get comparisonPositionTitle;

  /// No description provided for @lackOfChartTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any statistics yet'**
  String get lackOfChartTitle;

  /// No description provided for @wordAreOver.
  ///
  /// In en, this message translates to:
  /// **'The words are over'**
  String get wordAreOver;

  /// No description provided for @errorUpdAch.
  ///
  /// In en, this message translates to:
  /// **'Error updating achievement'**
  String get errorUpdAch;

  /// No description provided for @wrongWordTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Wrong word, try again.'**
  String get wrongWordTryAgain;

  /// No description provided for @errSwitchingToTheNextTransl.
  ///
  /// In en, this message translates to:
  /// **'Error switching to the next word translation:'**
  String get errSwitchingToTheNextTransl;

  /// No description provided for @trainingIsOver.
  ///
  /// In en, this message translates to:
  /// **'The training session is over.'**
  String get trainingIsOver;

  /// No description provided for @stillInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Still in development'**
  String get stillInDevelopment;

  /// No description provided for @incompletePage.
  ///
  /// In en, this message translates to:
  /// **'Incomplete page'**
  String get incompletePage;

  /// No description provided for @skipBtn.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipBtn;

  /// No description provided for @onboardingSubtitle5.
  ///
  /// In en, this message translates to:
  /// **'Transfer data over WI-FI or save it in a JSON file.'**
  String get onboardingSubtitle5;

  /// No description provided for @onboardingTitle5.
  ///
  /// In en, this message translates to:
  /// **'Share your dictionary without the Internet'**
  String get onboardingTitle5;

  /// No description provided for @onboardingSubtitle4.
  ///
  /// In en, this message translates to:
  /// **'With the help of data statistics, you can see your growth'**
  String get onboardingSubtitle4;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your progress'**
  String get onboardingTitle4;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Flashcards and other mini games will help you memorize foreign words.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Learn words by playing'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Group words by topic, level, or language, whichever suits you best.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Create folders and add words'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'This application specializes in improving the learning process of foreign language words.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Iskai app'**
  String get onboardingTitle1;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorTitle;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when importing data'**
  String get importError;

  /// No description provided for @importCanceled.
  ///
  /// In en, this message translates to:
  /// **'Data import has been canceled'**
  String get importCanceled;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data import completed'**
  String get importSuccess;

  /// No description provided for @importLoad.
  ///
  /// In en, this message translates to:
  /// **'Data is being imported'**
  String get importLoad;

  /// No description provided for @selectFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a file'**
  String get selectFileTitle;

  /// No description provided for @selectFileForImport.
  ///
  /// In en, this message translates to:
  /// **'Select the file with the extension .the json you want to import:'**
  String get selectFileForImport;

  /// No description provided for @filePathAfterEport.
  ///
  /// In en, this message translates to:
  /// **'The file was saved along the way:'**
  String get filePathAfterEport;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when exporting data'**
  String get exportError;

  /// No description provided for @exportCanceled.
  ///
  /// In en, this message translates to:
  /// **'Data export has been canceled.'**
  String get exportCanceled;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data export completed'**
  String get exportSuccess;

  /// No description provided for @exportLoad.
  ///
  /// In en, this message translates to:
  /// **'The data is being exported'**
  String get exportLoad;

  /// No description provided for @exportAndImportTitle.
  ///
  /// In en, this message translates to:
  /// **'When importing data, all previous data will be permanently deleted.'**
  String get exportAndImportTitle;

  /// No description provided for @importingDataTile.
  ///
  /// In en, this message translates to:
  /// **'Importing data'**
  String get importingDataTile;

  /// No description provided for @exportingDataTile.
  ///
  /// In en, this message translates to:
  /// **'Exporting data'**
  String get exportingDataTile;

  /// No description provided for @exportAndImportPage.
  ///
  /// In en, this message translates to:
  /// **'Exporting and importing data'**
  String get exportAndImportPage;

  /// No description provided for @receiveData.
  ///
  /// In en, this message translates to:
  /// **'Receive data'**
  String get receiveData;

  /// No description provided for @selectAction.
  ///
  /// In en, this message translates to:
  /// **'Select an action:'**
  String get selectAction;

  /// No description provided for @receivingBtn.
  ///
  /// In en, this message translates to:
  /// **'Receiving'**
  String get receivingBtn;

  /// No description provided for @sendingBtn.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get sendingBtn;

  /// No description provided for @dataReceiveSuccess.
  ///
  /// In en, this message translates to:
  /// **'The data was successfully received'**
  String get dataReceiveSuccess;

  /// No description provided for @dataReceiveLoad.
  ///
  /// In en, this message translates to:
  /// **'Data is being received'**
  String get dataReceiveLoad;

  /// No description provided for @cancelSend.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelSend;

  /// No description provided for @retrySend.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retrySend;

  /// No description provided for @dataFailedSent.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send data'**
  String get dataFailedSent;

  /// No description provided for @exitBtn.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitBtn;

  /// No description provided for @dataSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'The data has been sent successfully!'**
  String get dataSentSuccessfully;

  /// No description provided for @sendingDataToRecipent.
  ///
  /// In en, this message translates to:
  /// **'Sending data to the recipient'**
  String get sendingDataToRecipent;

  /// No description provided for @sendData.
  ///
  /// In en, this message translates to:
  /// **'Send data'**
  String get sendData;

  /// No description provided for @receiverIpAddress.
  ///
  /// In en, this message translates to:
  /// **'Recipient\'s IP address'**
  String get receiverIpAddress;

  /// No description provided for @qrScanTitle.
  ///
  /// In en, this message translates to:
  /// **'QR scanner is only available on mobile devices'**
  String get qrScanTitle;

  /// No description provided for @scanRecipientQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan the recipient\'s QR code'**
  String get scanRecipientQRCode;

  /// No description provided for @sendDataToLocalServerTitle.
  ///
  /// In en, this message translates to:
  /// **'Send data to IP:'**
  String get sendDataToLocalServerTitle;

  /// No description provided for @localServerStatus2.
  ///
  /// In en, this message translates to:
  /// **'The server is enabled'**
  String get localServerStatus2;

  /// No description provided for @localServerStatus1.
  ///
  /// In en, this message translates to:
  /// **'The server is turned off'**
  String get localServerStatus1;

  /// No description provided for @urQRCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your QR code for transmission over IP:'**
  String get urQRCodeTitle;

  /// No description provided for @stopReceivingData.
  ///
  /// In en, this message translates to:
  /// **'Stop receiving data'**
  String get stopReceivingData;

  /// No description provided for @receiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Click \'Receive\' to generate a QR code'**
  String get receiveTitle;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @selectTimeForWorkout.
  ///
  /// In en, this message translates to:
  /// **'Сhoose the time you want to complete the workout'**
  String get selectTimeForWorkout;

  /// No description provided for @timePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Spelling a word based on the translation of time'**
  String get timePageTitle;

  /// No description provided for @wordInFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Word:'**
  String get wordInFlashcard;

  /// No description provided for @translateInFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Translate:'**
  String get translateInFlashcard;

  /// No description provided for @noMoreWords.
  ///
  /// In en, this message translates to:
  /// **'No more words'**
  String get noMoreWords;

  /// No description provided for @highDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get highDifficulty;

  /// No description provided for @mediumDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumDifficulty;

  /// No description provided for @lowDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get lowDifficulty;

  /// No description provided for @nextWord.
  ///
  /// In en, this message translates to:
  /// **'Next word'**
  String get nextWord;

  /// No description provided for @showAnswer.
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get showAnswer;

  /// No description provided for @totalNumberAnswers.
  ///
  /// In en, this message translates to:
  /// **'Total number of answers: '**
  String get totalNumberAnswers;

  /// No description provided for @numberIncorrectAnswers.
  ///
  /// In en, this message translates to:
  /// **'Number of incorrect answers:'**
  String get numberIncorrectAnswers;

  /// No description provided for @numberCorrectAnswers.
  ///
  /// In en, this message translates to:
  /// **'Number of correct answers:'**
  String get numberCorrectAnswers;

  /// No description provided for @averageNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Average number of answers per day:'**
  String get averageNumberTitle;

  /// No description provided for @wordsLearned.
  ///
  /// In en, this message translates to:
  /// **'Words learned:'**
  String get wordsLearned;

  /// No description provided for @searchWords.
  ///
  /// In en, this message translates to:
  /// **'Search words'**
  String get searchWords;

  /// No description provided for @noWords.
  ///
  /// In en, this message translates to:
  /// **'There are no words'**
  String get noWords;

  /// No description provided for @noWordsDescription.
  ///
  /// In en, this message translates to:
  /// **'There are no words for the flashcards. Add new words or wait for words.'**
  String get noWordsDescription;

  /// No description provided for @showExitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to finish the workout?'**
  String get showExitDialogTitle;

  /// No description provided for @yesAction.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesAction;

  /// No description provided for @noAction.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noAction;

  /// No description provided for @globalSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Word folders are transferred through a server that mediates between the two devices. The server does not store any data, it only resends the database.'**
  String get globalSyncDescription;

  /// No description provided for @localSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'How does local sync work? You can transfer all your folders to another device via a Wi-Fi hotspot or when both devices are connected to the same Wi-Fi network.'**
  String get localSyncDescription;

  /// No description provided for @renameFolder.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameFolder;

  /// No description provided for @deleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteFolder;

  /// No description provided for @folderActionsPage.
  ///
  /// In en, this message translates to:
  /// **'Folder management'**
  String get folderActionsPage;

  /// No description provided for @allFlashcards.
  ///
  /// In en, this message translates to:
  /// **'All words'**
  String get allFlashcards;

  /// No description provided for @timePage.
  ///
  /// In en, this message translates to:
  /// **'For a while'**
  String get timePage;

  /// No description provided for @noWordsFound.
  ///
  /// In en, this message translates to:
  /// **'Words not found'**
  String get noWordsFound;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @daysGenitive.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysGenitive;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @deleteWord.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteWord;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @bgColor.
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get bgColor;

  /// No description provided for @interfaceAppColor.
  ///
  /// In en, this message translates to:
  /// **'The color of the app interface'**
  String get interfaceAppColor;

  /// No description provided for @interactionWithFolders.
  ///
  /// In en, this message translates to:
  /// **'Interaction with folders'**
  String get interactionWithFolders;

  /// No description provided for @exportAndImportFoldersInExcel.
  ///
  /// In en, this message translates to:
  /// **'Export and import folder'**
  String get exportAndImportFoldersInExcel;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share app'**
  String get shareApp;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateUs;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.2.2'**
  String get appVersion;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
