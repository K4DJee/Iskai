import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/pages/export_data_page.dart';
import 'package:iskai/pages/import_data_page.dart';

class ExportImportActionsPage extends StatefulWidget {
  const ExportImportActionsPage({super.key});

  @override
  State<ExportImportActionsPage> createState() =>
      _ExportImportActionsPageState();
}

class _ExportImportActionsPageState extends State<ExportImportActionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.exportAndImportPage),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExportDataPage()),
                  );
                },
                title: Text(
                  AppLocalizations.of(context)!.exportingDataTile,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 1, thickness: 1),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImportDataPage()),
                  );
                },
                title: Text(
                  AppLocalizations.of(context)!.importingDataTile,
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
