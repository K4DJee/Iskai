import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/pages/local_sync_page.dart';
import 'package:iskai/pages/incomplete_page.dart';

class SyncPage extends StatefulWidget{
  const SyncPage({super.key});


  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.synchronizationPage),
      ),
      body:Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Expanded(child: Column(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.localSync,
              style: TextStyle(fontSize: 18, fontWeight:FontWeight.w500),),
              trailing: Icon(Icons.keyboard_arrow_right),
              selectedTileColor: Colors.black,
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const LocalSyncPage()));
              }

            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.localSyncDescription,
              style: TextStyle(fontSize: 18),),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.globalSync,
              style: TextStyle(fontSize: 18, fontWeight:FontWeight.w500)),
              trailing: Icon(Icons.keyboard_arrow_right),
              selectedTileColor: Colors.black,
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const IncompletePage()));
              }
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.globalSyncDescription,
              style: TextStyle(fontSize: 18),),
            ),
          ],
        ),)
      ],),)
    );
  }
}