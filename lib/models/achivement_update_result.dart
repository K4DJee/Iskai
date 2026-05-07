class AchievementUpdateResult {
  final bool success;
  final bool unlocked;
  final String? message;
  final String? achivementName;
  final Object? error;
  final int? achId;

  AchievementUpdateResult.success({
    required this.unlocked,
    this.achivementName,
    this.achId,
    this.message = 'Прогресс обновлён',
  })  : success = true,
        error = null;

  AchievementUpdateResult.failure({
    this.message = 'Ошибка обновления',
    this.error,
  })  : success = false,
        unlocked = false,
        achivementName = null,
        achId = null;
}