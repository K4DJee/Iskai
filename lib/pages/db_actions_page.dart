import 'package:flutter/material.dart';
import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/pages/export_data_page.dart';
import 'package:iskai/pages/import_data_page.dart';
import 'package:iskai/providers/FolderUpdateProvider.dart';
import 'package:iskai/services/modal_service.dart';
import 'package:provider/provider.dart';

class DBActionsPage extends StatefulWidget {
  const DBActionsPage({super.key});

  @override
  State<DBActionsPage> createState() => _DBActionsPageState();
}

class _DBActionsPageState extends State<DBActionsPage> {
  String dbSize = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadDBSize();
  }

  Future<void> _loadDBSize() async {
    final size = await SQLiteDatabase.instance.getDatabaseSize();
    setState(() {
      dbSize = formatBytes(size);
    });
  }

  String formatBytes(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(2)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.interactionWithTheDB),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                title: Text(
                  "${AppLocalizations.of(context)!.dbSize} $dbSize",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 1, thickness: 1),
              ListTile(
                onTap: () async {
                  ModalService.showImportantMessage(
                    AppLocalizations.of(context)!.warningTitleInModal,
                    AppLocalizations.of(context)!.deleteDbDescInModal,
                    [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.doNotDeleteDbBtnInModal,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await SQLiteDatabase.instance.deleteDatabaseFile();
                          context
                              .read<FolderUpdateProvider>()
                              .notifyFolderUpdated();

                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.deleteDbBtnInModal,
                        ),
                      ),
                    ],
                  );
                },
                title: Text(
                  AppLocalizations.of(context)!.deleteDbTitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
