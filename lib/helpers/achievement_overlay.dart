import 'package:flutter/material.dart';
import 'package:iskai/widgets/achievement_popup.dart';

void showAchievementPopup(BuildContext context, String achievemntName){
    final overlay = Overlay.of(context);
    if(overlay == null) return;
    
    final overlayEntry = OverlayEntry(builder: (context){
      return Positioned(
         left: 0,
      right: 0,
      bottom: MediaQuery.of(context).padding.bottom,
      child: AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300),
      child: AchievementPopup(achievementName: achievemntName),
  )
      );
    });

    overlay.insert(overlayEntry);
    // if (!overlayEntry.mounted) return;
    // overlayEntry.remove();
    Future.delayed(Duration(seconds:3), (){
      overlayEntry.remove();
    });
  }