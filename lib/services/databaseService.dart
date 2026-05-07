import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/models/achievement.dart';
import 'package:iskai/models/achivement_update_result.dart';
import 'package:iskai/models/daily_streak_info.dart';
import 'package:iskai/models/folders.dart';
import 'package:iskai/models/statistics.dart';
import 'package:iskai/models/streak_update_result.dart';
import 'package:iskai/models/user_statistics.dart';
import 'package:iskai/models/words.dart';

class DatabaseService {
  final SQLiteDatabase _db = SQLiteDatabase.instance;
  Future<List<Folders>> loadFolders() async {
    print('Начало загрузки папок...');
    try {
      final folders = await _db.getFolders();
      print('Получен список папок: ${folders.map((f) => f.name).join(', ')}');
      return folders;
    } catch (e) {
      print('Ошибка загрузки папок: $e');
      rethrow;
    }
  }

  Future<List<Words>> loadWordsFromFolder(int folderId) async {
    print('Загрузка слов для папки с ID $folderId');
    try {
      final words = await _db.getWords(folderId);
      print('Получен список слов: ${words.map((w) => w.word).join(', ')}');
      return words;
    } catch (e) {
      print('Ошибка загрузки слов: $e');
      rethrow;
    }
  }

  Future<int> createFolder(String folderName) async {
    print('Попытка создания папки: $folderName');
    try {
      final newFolder = Folders(id: null, name: folderName);
      print('Создан объект папки: ${newFolder.toMap()}');
      final folderId = await _db.createFolder(newFolder);
      if (folderId == 0) {
        print('Ошибка создания новой папки, такая папка уже существует');
        return folderId;
      }
      return folderId;
    } catch (e) {
      print('Ошибка создания папки $e');
      rethrow;
    }
  }

  Future<void> addWord(Words word) async {
    print('Попытка добавления слова');
    try {
      await _db.addWord(word);
    } catch (e) {
      print('Ошибка добавления слова: $e');
      rethrow;
    }
  }

  Future<void> deleteFolder(int id) async {
    try {
      final result = await _db.deleteFolder(id);
      if (result == 0) {
        print('Ошибка удаления папки, такой папки не существует');
      }
      await loadFolders();
    } catch (e) {
      print('Ошибка удаления папки: $e');
    }
  }

  Future<void> deleteWord(int id) async {
    try {
      final result = await _db.deleteWord(id);
      if (result == 0) {
         print('Такое слово не существует');
      }
    } catch (e) {
      print('Ошибка удаления слова: $e');
      rethrow;
    }
  }

  Future<void> changeWord(Words word) async {
    try {
      final result = await _db.changeWord(word);
      if (result == 0) {
        print("Ошибка изменения слова, такого слов не существует");
      }
      print('Слово успешно изменилось c ID$result');
    } catch (e) {
      print('Ошибка изменения слова: $e');
      rethrow;
    }
  }

  Future<List<Words>?> getFlashcards(int folderId, {int page = 1, int limit = 25})async{
    try{
      print('Начало получения flashcards');
      final flashcards = await _db.getFlashcards(folderId, page:page, limit:limit);
      if(flashcards == null){
        print('Слов нету');
        return null;
      }
      print('flashcards получены: $flashcards');
      return flashcards;
    }
    catch(e){
      print('Ошибка получения flashcards: $e');
    }
    return null;
  }

  Future<void> createStatisticDay(int folderId, Statistics statistic)async{
    try{
      final statisticDay = await _db.createStatisticDay(folderId, statistic);
      if(statisticDay != 0){
        print('Статистика успешно была создана или обновлена');
      }
      else{
        print('Ошибка создания или обновления статистики');
      }
    }
    catch(e){
      print('Ошибка создания статистики: $e');

    }
  }

  Future<void> importWordsToFolder(int folderId, List<Map<String, dynamic>> wordsData)async{
  try{
    for(var data in wordsData){
      final word = Words(
        folderId: folderId,
        word: data['word'],
        translate: data['translate'],
        example: data['example']
      );

      await _db.addWord(word);
    }
  }
  catch(e){
    print('Ошибка: $e');
    rethrow;
  }
}

Future<void> deleteDatabaseFile()async{
  try{
    await _db.deleteDatabaseFile();
  }
  catch(e){
    print('Ошибка: $e');
    rethrow;
  }
}

Future<AchievementUpdateResult> updateProcessOfAchievement(int id, int newProgress)async{
  try{
    int result = await _db.updateProcessOfAchievement(id, newProgress);
    if(result != -1 && result != 0 ){
      print('Достижение разблокировано!');
    Achievement? achievement = await _db.getAchivementInfo(result);
     if (achievement == null) {
        print('Ошибка: достижение с ID $result не найдено в БД!');
        return AchievementUpdateResult.failure(
          message: 'Не удалось загрузить информацию о разблокированном достижении.',
        );
      }
      return AchievementUpdateResult.success(
          unlocked: true,
          achivementName: achievement.name,
          message: 'Достижение разблокировано!',
      );
    } 
    else{
      print('Прогресс достижения обновлён');
      return AchievementUpdateResult.success(
          unlocked: false,
          message: 'Прогресс обновлён!',
        );
    }
    
  }
  catch(e){
    print("Ошибка updateProccessOfAchievement: $e");
    return AchievementUpdateResult.failure(
        message: 'Достижение разблокировано!',
    );
  }
}

Future<AchievementUpdateResult> updateProcessOfStreakInAchivement(List<int> ids, int newProgress)async{
  try{
    int result = await _db.updateProcessOfStreakInAchivement(ids, newProgress);
    if(result != -1 && result != 0 ){
    Achievement? achievement = await _db.getAchivementInfo(result);
    if (achievement == null) {
        print('Ошибка: достижение с ID $result не найдено в БД!');
        return AchievementUpdateResult.failure(
          message: 'Не удалось загрузить информацию о разблокированном достижении.',
        );
      }
      return AchievementUpdateResult.success(
          achId: result,
          unlocked: true,
          achivementName: achievement.name,
          message: 'Достижение разблокировано!',
      );
    } 
    else if(result == -1){
      print('Прогресс достижения обновлён');
      return AchievementUpdateResult.success(
          unlocked: false,
          message: 'Прогресс обновлён!',
        );
    }
    else{
      print('Прогресс достижения не обновлён');
      return AchievementUpdateResult.success(
          unlocked: false,
          message: 'Прогресс не обновлён!',
        );
    }
  }
  catch(e){
    print("Ошибка updateProcessOfStreakInAchivement: $e");
    return AchievementUpdateResult.failure(
        message: 'Достижение разблокировано!',
    );
  }
}

Future<StreakUpdateResult> createUserStatistics(UserStatistics userStatistics)async{
  try{
    
    int result = await _db.createUserStatistics(userStatistics);
    print("streak: ${result}");
    if(result == 0){
      print('Стрик не надо ещё обновлять');
    }

    return StreakUpdateResult.success(streak: result);
  }
  catch(e){
    print('Ошибка работы с ударным режимом: $e');
    return StreakUpdateResult.failure(message: 'Ошибка в работе с ударным режимом');
  }
}

Future<Achievement?> getAchivementInfo(int id)async{
  return await _db.getAchivementInfo(id);
}

Future<DailyStreakInfo> getDailyStreakInfo()async{
  try{
    return await _db.getDailyStreakInfo();
  }
  catch(e){
    print('Ошибка: $e');
    return DailyStreakInfo(currentStreak: 0, maxDailyStreak: 0);
  }
}


}