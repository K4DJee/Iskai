import 'package:iskai/l10n/app_localizations.dart';

extension AchievementLocalization on AppLocalizations{
  String achievementName(int id) {
    switch (id) {
      case 1:
        return achievementName1;
      case 2:
        return achievementName2;
      case 3:
        return achievementName3;
      case 4:
        return achievementName4;
      case 5:
        return achievementName5;
      case 6:
        return achievementName6;
      case 7:
        return achievementName7;
      case 8:
        return achievementName8;
      case 9:
        return achievementName9;
      case 10:
        return achievementName10;
      case 11:
        return achievementName11;
      default:
        return "Achievement $id";
    }
  }

  String achievementDescription(int id) {
    switch (id) {
      case 1:
        return achievementDescription1;
      case 2:
        return achievementDescription2;
      case 3:
        return achievementDescription3;
      case 4:
        return achievementDescription4;
      case 5:
        return achievementDescription5;
      case 6:
        return achievementDescription6;
      case 7:
        return achievementDescription7;
      case 8:
        return achievementDescription8;
      case 9:
        return achievementDescription9;
      case 10:
      return achievementDescription10;
      case 11:
      return achievementDescription11;
      default:
        return "";
    }
  }
}