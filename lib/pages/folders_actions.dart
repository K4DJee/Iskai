import 'package:flutter/material.dart';
import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/folders.dart';
import 'package:iskai/pages/folderNamePage.dart';
import 'package:iskai/providers/FolderUpdateProvider.dart';
import 'package:provider/provider.dart';

class folderActionsPage extends StatefulWidget{
  const folderActionsPage({super.key});

  @override
  State<folderActionsPage> createState() => _folderActionsPageState();
}

class _folderActionsPageState extends State<folderActionsPage>{
  List<Folders> _folders = [];
  final SQLiteDatabase _sqfliteDatabase = SQLiteDatabase.instance;

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    // print('Начало загрузки папок...');
    try {
      final folders = await _sqfliteDatabase.getFolders();
      // print('Получен список папок: ${folders.map((f) => f.name).join(', ')}');
      setState(() {
        _folders = folders;
      });
    } catch (e) {
      // print('Ошибка загрузки папок: $e');
      setState(() {

      });
    }
  }

  Future<void> _deleteFolder(int? id) async{
    // print('Начало удаления папки');
    try{
      final deletedFolder = await _sqfliteDatabase.deleteFolder(id!);
      if(deletedFolder == 0){
        // print('Ошибка удаления папки, папка не существует');
      }
      else{
        // print('Папка с ID #$id была успешно удалена');
        
        await _loadFolders();

      }
    }
    catch(e){
      // print('Ошибка удаления папки: $e');
    }
  }

  Future<void> saveNewFolderName(int? id, String name)async{
    // print('Начало сохранения нового имени папки');
    try{
      //changeFolderName
      final changeFolder = await _sqfliteDatabase.changeFolderName(id!, name);
      if(changeFolder == 0){
        // print('Ошибка изменения папки. Папки может не существует');
      }
      else{
        _loadFolders();
        // print('Название папки было успешно изменено');
      }
    }
    catch(e){
      // print('Ошибка изменения папки: $e');
    }
  }


  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.folderActionsPage),
      ),
      body: ListView.separated(
        itemCount: _folders.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
        ),
        itemBuilder: (context, index){
          final folder = _folders[index];
          final folderName = folder.name;
          return ListTile(
            title:Text(folderName, style:TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (value)async{
                final controller = TextEditingController(text: folder.name);
                if(value == "rename"){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => 
                 FolderNamePage(
                  folder: folder,
                  controller: controller, 
                  onSave: (updatedFolder) async{
                  await saveNewFolderName(updatedFolder.id, updatedFolder.name);
                  context.read<FolderUpdateProvider>().notifyFolderUpdated();
                  Navigator.of(context).pop();
                 }))); 
                }
                else if(value == "delete"){
                 await _deleteFolder(folder.id);
                 context.read<FolderUpdateProvider>().notifyFolderUpdated();
                }
              },
              itemBuilder: (context)=>[
                PopupMenuItem(
                  value: 'rename',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      Text(AppLocalizations.of(context)!.renameFolder),
                    ],
                  )
                  ),
                  PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18),
                      Text(AppLocalizations.of(context)!.deleteFolder),
                    ],
                  )
                  )
              ],
              ),
          );
        },
      )
    );
  }
}