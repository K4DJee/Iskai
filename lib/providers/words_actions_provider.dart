
import 'package:flutter/foundation.dart';

class WordsActionsProvider with ChangeNotifier{
  int _wordsPassed = 0;

  int get wordsPassed => _wordsPassed;

  void addWords(int count){
  if(count > 0){
    _wordsPassed += count;
    notifyListeners();
  }
}

  void reset(){
    _wordsPassed = 0;
    notifyListeners();
  }

  Future<void> loadFromStorage()async{

  }

  Future<void> saveToStorage()async{
    
  }
}