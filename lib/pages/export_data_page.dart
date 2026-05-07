import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/l10n/app_localizations.dart';

class ExportDataPage extends StatefulWidget{
  const ExportDataPage({super.key});

  @override
  State<ExportDataPage> createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage>{
  String? exportedFilePath;
  bool _isLoading = true;
  bool _isSuccess = false;
  bool _isError = false;
  String? errorMessage;
  Future<void> exportDBToFile()async{
    try{
     final jsonString = await SQLiteDatabase.instance.exportDatabaseToJson();
    final bytes = utf8.encode(jsonString);
     exportedFilePath = await FileSaver.instance.saveAs(
        name: 'iskai_backup',
        bytes: bytes,
        fileExtension: 'json',
        mimeType: MimeType.json,
      );
      if (context.mounted) {
        setState(() {
          _isSuccess = true;
          _isLoading = false;
        });
      }
  }
    catch(e){
      if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.errorTitle} $e')),
      );
      setState(() {
        _isError = true;
        _isLoading = false;
      });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        exportDBToFile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.exportingDataTile),
      ),
      body:  Center(
        child: _isSuccess
        ? _buildSuccessView()
        : _isError 
          ? _buildErrorView()
          :_buildLoadingView()
      ),
    );
  }

  Widget _buildLoadingView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height:8),
        Text(AppLocalizations.of(context)!.exportLoad, style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),),
        SizedBox(height:8),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.exitBtn)
         )
      ],
    );
  }
  
  Widget _buildSuccessView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: Colors.blue, size: 64,),
        SizedBox(height:8),
        if(exportedFilePath != null)...[
          Text(AppLocalizations.of(context)!.exportSuccess, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
          Text('${AppLocalizations.of(context)!.filePathAfterEport} $exportedFilePath', style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          )),
        ]
        else...[  
          Text(AppLocalizations.of(context)!.exportCanceled,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          )),
        ],
        SizedBox(height: 8,),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.exitBtn)
         )
      ],
    );
  }

  Widget _buildErrorView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height:24),
        Text(AppLocalizations.of(context)!.exportError),
        Text(AppLocalizations.of(context)!.errorTitle),
        SizedBox(),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.exitBtn)
         )
      ],
    );
  }
}