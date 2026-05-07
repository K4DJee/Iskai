import 'package:flutter/material.dart';
import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/pages/export_data_page.dart';
import 'package:iskai/pages/import_data_page.dart';
import 'package:iskai/providers/FolderUpdateProvider.dart';
import 'package:provider/provider.dart';

class NotificationActionsPage extends StatefulWidget {
  const NotificationActionsPage({super.key});

  @override
  State<NotificationActionsPage> createState() => _NotificationActionsPageState();
}

class _NotificationActionsPageState extends State<NotificationActionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Interaction with the database")),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                onTap: () {
                  //Размер
                },
                title: Text(
                  "Size of the database:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 1, thickness: 1),
              ListTile(
                onTap: () async{
                 //warning
                 await SQLiteDatabase.instance.deleteDatabaseFile();
                context.read<FolderUpdateProvider>().notifyFolderUpdated();
                },
                title: Text(
                  "Delete the database",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Text(
              AppLocalizations.of(context)!.exportAndImportTitle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
