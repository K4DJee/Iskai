import 'package:flutter/material.dart';
import 'package:iskai/models/folders.dart';
import 'package:iskai/models/words.dart';
import 'package:iskai/services/databaseService.dart';

class WordsProvider extends ChangeNotifier{
  final DatabaseService _dbService;
  WordsProvider(this._dbService);

  List<Folders> folders = [];
  List<Words> words = [];
  List<Words> filteredWords = [];

  Folders? selectedFolder;
  int? selectedFolderId;
  bool isLoading = false;
  String? error;

  String _searchQuery = '';

  bool _isOperationInProgress = false;

  //methods
  Future<void> init() async{
    await loadFolders();
     if (selectedFolderId != null) {
      await loadWords(selectedFolderId!);
    } else if (folders.isNotEmpty) {
      await selectFolder(folders.first.id, load: true);
    }
  }

  Future<void> loadFolders() async{
    isLoading = true;
    notifyListeners();
    try{
      final result = await _dbService.loadFolders();
      folders = result;
      if(selectedFolderId !=null && !folders.any((f) => f.id == selectedFolderId)){
        if (folders.isNotEmpty) {
          selectedFolderId = folders.first.id;
          selectedFolder = folders.first;
          print("selectedFolder: $selectedFolder");
        } else {
          selectedFolderId = null;
          selectedFolder = null;
          words = [];
          filteredWords = [];
        }
      }
    }
    catch(e){
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
    finally {
    isLoading = false;
    notifyListeners();
  }
  }

  Future<void> selectFolder(int? id, {bool load = true})async{
    selectedFolderId = id;
    notifyListeners();
    if(id != null && load){
      await loadWords(id);
      selectedFolder = folders.firstWhere((f) => f.id == id);
    }
    else if(id == null){
      words = [];
      filteredWords = [];
      notifyListeners();
    }
  }

  Future<void> loadWords(int folderId) async{
    isLoading = true;
    notifyListeners();
    try{
      final result = await _dbService.loadWordsFromFolder(folderId);
      words = result;
      _applyFilter();
      isLoading = false;
      error = null;
      notifyListeners();
    } 
    catch(e){
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  Future<int> addFolderAndSelect(String name)async{
    if (_isOperationInProgress) {
      // optional: reject or wait
    }
    _isOperationInProgress = true;
    try{
      final newId = await _dbService.createFolder(name);
      await loadFolders();
      selectedFolderId = newId;
      await selectFolder(newId);
      await loadWords(newId);
      return newId;
    }
    finally {
      _isOperationInProgress = false;
    }
  }

  Future<void> addFolder(String name)async{
    await addFolderAndSelect(name);
  }

  Future<void> deleteFolder(int id)async{
    _isOperationInProgress =true;

    try{
      await _dbService.deleteFolder(id);
      await loadFolders();
      if (selectedFolderId != null) {
        await loadWords(selectedFolderId!);
      }
    }
    finally {
      _isOperationInProgress = false;
    }
  }

  Future<void> addWord(Words word)async{
    _isOperationInProgress = true;
    try{
      await _dbService.addWord(word);
      if (word.folderId != null && word.folderId == selectedFolderId) {
        await loadWords(selectedFolderId!);
      }
    }
    finally {
      _isOperationInProgress = false;
    }
  }

  Future<void> updateWord(Words word)async{
    _isOperationInProgress = true;
    try{
      await _dbService.changeWord(word);
      if (word.folderId != null && word.folderId == selectedFolderId) {
        await loadWords(selectedFolderId!);
      }
    }
    finally{
      _isOperationInProgress = false;
    }
  }
  Future<void> deleteWord(int id)async{
    _isOperationInProgress = true;
    try{
      await _dbService.deleteWord(id);
      if (selectedFolderId != null) {
        await loadWords(selectedFolderId!);
      }
    }
    finally{
      _isOperationInProgress = false;
    }
  }


  //
  void setSearchQuery(String q) {
    _searchQuery = q.toLowerCase().trim();
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      filteredWords = List.from(words);
    } else {
      filteredWords = words.where((w) {
        final wWord = w.word.toLowerCase();
        final wTranslate = w.translate.toLowerCase();
        final wExample = w.example.toLowerCase();
        return wWord.contains(_searchQuery) ||
            wTranslate.contains(_searchQuery) ||
            wExample.contains(_searchQuery);
      }).toList();
    }
  }
} 