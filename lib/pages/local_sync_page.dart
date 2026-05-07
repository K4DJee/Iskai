import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/widgets/userReceiverLocal.dart';
import 'package:iskai/widgets/userSenderLocal.dart';
class LocalSyncPage extends StatefulWidget{
  const LocalSyncPage({super.key});

  @override
  State<LocalSyncPage> createState() => _LocalSyncPageState();
}

class _LocalSyncPageState extends State<LocalSyncPage>{
    int indexPage = 0;
    List<Widget> widgetList = [
      UserReceiverLocal(),
      UserSenderLocal()
    ];

    bool isChoiceSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(AppLocalizations.of(context)!.localSync),
      
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            setState(() {
              indexPage = index;
              if(isChoiceSelected == false){
                isChoiceSelected = true;
              }
            });
          },
          currentIndex: indexPage ,
          items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: AppLocalizations.of(context)!.receivingBtn,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner), 
            label: AppLocalizations.of(context)!.sendingBtn,
          ),
      ]),
      body: isChoiceSelected 
      ? widgetList[indexPage]
      : Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.selectAction),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: (){
              setState(() {
                indexPage = 0;
                isChoiceSelected = true;
              });
            }, child: Text(AppLocalizations.of(context)!.receiveData)),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              setState(() {
                indexPage = 1;
                isChoiceSelected = true;
              });
            }, child: Text(AppLocalizations.of(context)!.sendData)),
          ],
        ),
      )
    );
  }
}


class Device {
  final String deviceId;
  final String deviceName;

  Device({required this.deviceId, required this.deviceName});
}