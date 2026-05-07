import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/pages/all_flashcards_page.dart';
import 'package:iskai/pages/comparison_minigame.dart';
import 'package:iskai/pages/flashcards_page.dart';
import 'package:iskai/pages/time_flashcards_page.dart';

class MinigamesPage extends StatefulWidget {
  final int selectedFolderId;
  const MinigamesPage({super.key, required this.selectedFolderId});

  @override
  State<MinigamesPage> createState() => _MinigamesPageState();
}

class _MinigamesPageState extends State<MinigamesPage>{
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> minigames = [
      {
        "title": AppLocalizations.of(context)!.educationAnki,
        "image": "assets/imgs/anki.png",
        "page": () => FlashcardPage(selectedFolderId: widget.selectedFolderId,)
      },
      {
        "title": AppLocalizations.of(context)!.allFlashcards,
        "image": "assets/imgs/dictionary-icon.png",
        "page": () => AllFlashcardsPage(selectedFolderId: widget.selectedFolderId,)
      },
      {
        "title": AppLocalizations.of(context)!.timePage,
        "image": "assets/imgs/timer-icon.png",
        "page": ()=> TimeFlashcardsPage(selectedFolderId: widget.selectedFolderId,)
      },
      {
        "title": AppLocalizations.of(context)!.comparisonMinigameTitle,
        "image": "assets/imgs/comparison3.png",
        "page": ()=> ComparisonMinigame(selectedFolderId: widget.selectedFolderId,)
      }
      
     ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.minigamesPage),
      ),
      body: minigames.isNotEmpty
      ? ListView.separated(
        itemCount: minigames.length,
        padding: EdgeInsets.only(left:10, right:10),
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index){
          print(widget.selectedFolderId);
           return minigameContainer(context, minigames[index], minigames[index]['page'] as Widget Function());
        },
      )
      : Center(child: CircularProgressIndicator()),
    );
  }
}


Widget minigameContainer(BuildContext context, minigame, Widget Function() pageBuilder,){
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(2),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        width:2
      )
    ),
    child:ListTile(
      title:  Text(minigame['title'], textAlign: TextAlign.left,  style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),),
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> pageBuilder())),
      leading: ImageIcon(
                AssetImage(minigame['image']),
      ),
    )
  );
}