//Settings Page
import 'package:flutter/material.dart';
import 'package:iskai/helpers/themes.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/languages.dart';
import 'package:iskai/pages/comparison_minigame.dart';
import 'package:iskai/pages/db_actions_page.dart';
import 'package:iskai/pages/export_import_actions_page.dart';
import 'package:iskai/pages/folders_actions.dart';
import 'package:iskai/pages/minigames_page.dart';
import 'package:iskai/pages/privacy_police_page.dart';
import 'package:iskai/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:iskai/providers/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool light = false;
  Languages? _selectedLanguageItem;
  late String _selectedCodeLanguage;
  bool notificationsEnabled = true;

  Future<void> _openFeedbackUrl() async {
    final url = Uri.parse("https://t.me/k4dje_feedback");

    try {
      await launchUrl(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  Future<void> _openRateUsUrl() async {
    final url = Uri.parse(
      "https://www.rustore.ru/catalog/app/studio.k4dje.iskai",
    );

    try {
      await launchUrl(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  Future<void> _shareApp() async {
    final text =
        'Попробуйте Isky — удобный словарь для изучения иностранных языков!\n\n'
        'Доступно в RuStore: https://www.rustore.ru/catalog/app/studio.k4dje.iskai';
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  void initState() {
    super.initState();
    _loadNotificationState();
  }

  Future<void> _loadNotificationState()async{
    final prefs = await SharedPreferences.getInstance();
    final disabled = prefs.getBool('notifications_disabled') ?? false;

    setState(() {
      notificationsEnabled = !disabled;
    });
  }

  String _getLanguageNameByCode(String code, BuildContext context) {
    switch (code) {
      case 'en':
        return AppLocalizations.of(context)!.languageNameEn;
      case 'ru':
        return AppLocalizations.of(context)!.languageNameRu;
      case 'fr':
        return AppLocalizations.of(context)!.languageNameFr;
      case 'es':
        return AppLocalizations.of(context)!.languageNameEs;
      default:
        return AppLocalizations.of(context)!.selectLanguage;
    }
  }

  void _showLanguagePicker(BuildContext context) {
    final List<Languages> _languages = [
      Languages(lang: AppLocalizations.of(context)!.languageNameEn, code: 'en'),
      Languages(lang: AppLocalizations.of(context)!.languageNameRu, code: 'ru'),
      Languages(lang: AppLocalizations.of(context)!.languageNameFr, code: 'fr'),
      Languages(lang: AppLocalizations.of(context)!.languageNameEs, code: 'es'),
    ];
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.selectLanguage,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final lang = _languages[index];
                return ListTile(
                  title: Text(lang.lang),
                  onTap: () {
                    setState(() {
                      _selectedLanguageItem = lang;
                      _selectedCodeLanguage = lang.code;
                    });
                    localeProvider.setLocale(Locale(lang.code));
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLanguageCode = localeProvider.locale?.languageCode ?? 'en';

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingsPage)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: themeProvider.isDark,
            title: Text(
              AppLocalizations.of(context)!.bgColor,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeThumbColor: const Color.fromARGB(255, 77, 183, 58),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          SwitchListTile(value: notificationsEnabled, 
          title: Text(AppLocalizations.of(context)!.displayNotificationsTitle, style:TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500
          )),
          activeThumbColor: const Color.fromARGB(255, 77, 183, 58),
          onChanged: (value)async{
            setState(() {
              notificationsEnabled = value;
            });

            if (value){
              await NotificationService.activateShowModal();
            } else{
              await NotificationService.disableShowModal();
            }
          }), 
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.interactionWithFolders,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.folder),
            selectedTileColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const folderActionsPage(),
                ),
              );
            },
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.interactionWithTheDB,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.storage),
            selectedTileColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DBActionsPage()),
              );
            },
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.exportAndImportFoldersInExcel,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.folder_copy_rounded),
            selectedTileColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExportImportActionsPage(),
                ),
              );
            },
          ),
          // const Divider(height: 1, thickness: 1, color: Colors.grey),
          // ListTile(//remove ads
          //   title:Text(AppLocalizations.of(context)!.removeAds,
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          //   trailing: Icon(Icons.close),
          //   selectedTileColor: Colors.black,
          //   onTap:(){
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>const IncompletePage()));
          //   }
          // ),
          
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          InkWell(
            onTap: () {
              _showLanguagePicker(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        _getLanguageNameByCode(
                          localeProvider.locale?.languageCode ??
                              AppLocalizations.of(context)!.selectLang,
                          context,
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ), //Share app
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.shareApp,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.share),
            selectedTileColor: Colors.black,
            onTap: () => _shareApp(),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey), //rate us
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.rateUs,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.reviews),
            selectedTileColor: Colors.black,
            onTap: () => _openRateUsUrl(),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.feedback,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.feedback),
            selectedTileColor: Colors.black,
            onTap: () async {
              await _openFeedbackUrl();
            },
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.privacyPolicy,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.privacy_tip),
            selectedTileColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicePage()),
              );
            },
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.appVersion,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
