import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const _disabledKey = 'notifications_disabled';
  static const _lastShownKey = 'last_shown';


  static Future<bool> shouldShowModal()async{
    final prefs = await SharedPreferences.getInstance();

    final disabled = prefs.getBool(_disabledKey) ?? false;
    if(disabled) return false;

    final now = DateTime.now();

    const _firstLaunchKey = 'modal_first_launch_time';
    final firstLaunchMillis = prefs.getInt(_firstLaunchKey) ?? now.millisecondsSinceEpoch;

    if(prefs.getInt(_firstLaunchKey) == null){
      await prefs.setInt(_firstLaunchKey, firstLaunchMillis);
    }

    final firstLaunchDate = DateTime.fromMillisecondsSinceEpoch(firstLaunchMillis);
    if(now.difference(firstLaunchDate).inDays < 2){
      return false;
    }

    final lastShownMillis = prefs.getInt(_lastShownKey);
    
    if (lastShownMillis == null) return true;

    final lastShown = DateTime.fromMillisecondsSinceEpoch(lastShownMillis);

    return now.difference(lastShown).inDays >= 7;
  }

  static markShownModal()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
    _lastShownKey,
    DateTime.now().millisecondsSinceEpoch,
  );
  }

  static Future<void> disableShowModal()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_disabledKey, true);
  }

  static Future<void> activateShowModal()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_disabledKey, false);
  }
}