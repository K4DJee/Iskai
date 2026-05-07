import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/words.dart';

class WordActionsPage  extends StatefulWidget{
  final Words word;
  final Function(Words) onSave;
  final Function(int) onDelete; 
  const WordActionsPage({super.key, 
    required this.word,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<WordActionsPage> createState()=> _WordActionsPageState();
}

class _WordActionsPageState extends State<WordActionsPage>{
  late TextEditingController _wordController;
  late TextEditingController _translateController;
  late TextEditingController _exampleController;

  
  
  @override
  void initState(){
    super.initState();
    _wordController = TextEditingController(text: widget.word.word);
    _translateController = TextEditingController(text: widget.word.translate);
    _exampleController = TextEditingController(text: widget.word.example);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
      appBar: AppBar(
      title: Text(AppLocalizations.of(context)!.wordActionsTitle), 
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
       
        child: Column(
          children: [
            TextField(
              controller: _wordController,
              autofocus: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.wordInput,
                border:OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _translateController,
              autofocus: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translateInput,
                border:OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _exampleController,
              autofocus: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.exampleInput,
                border:OutlineInputBorder(),

              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                final updatedWord = Words(
                  id: widget.word.id,
                  folderId: widget.word.folderId,
                  word: _wordController.text.trim(),
                  translate: _translateController.text.trim(),
                  example: _exampleController.text.trim(),
                );

                widget.onSave(updatedWord);
                HapticFeedback.vibrate();
                // Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ), child:  Text(AppLocalizations.of(context)!.showBottomSheetChange)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                widget.onDelete(widget.word.id!);
                HapticFeedback.heavyImpact();
                Navigator.pop(context);
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ), child:  Text(AppLocalizations.of(context)!.deleteWord)),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                    foregroundColor: Colors.white
                  ),
                  onPressed: () => Navigator.pop(context),
                  child:  Text(AppLocalizations.of(context)!.closeButton),
                ),
              ),
            ]),
      ),
    ),
    );
  }
}