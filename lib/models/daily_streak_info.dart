class DailyStreakInfo {
   final int currentStreak;
  final int maxDailyStreak;


  DailyStreakInfo({
    required this.currentStreak,
    required this.maxDailyStreak
  });

  Map<String, dynamic> toMap() =>{
    'currentStreak': currentStreak,
    'maxDailyStreak': maxDailyStreak,
  };
  
  factory DailyStreakInfo.fromMap(Map<String, dynamic> map) => DailyStreakInfo(
    currentStreak: map['currentStreak'],
     maxDailyStreak: map['maxDailyStreak']
     );
}