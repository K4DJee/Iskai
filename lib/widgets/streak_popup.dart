import 'package:flutter/material.dart';
import 'package:iskai/helpers/formatDayEnding.dart';
import 'package:iskai/l10n/app_localizations.dart';

class StreakPopup  extends StatelessWidget{
  final int streak;

  const StreakPopup({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding:  EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/animations/fire.gif',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 10,),
              if(streak == 1)
              Text('$streak ${formatDayEnding(streak, context)}!', style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),)
              else
              Text('$streak ${formatDayEnding(streak, context)} ${AppLocalizations.of(context)!.streakTitle}!', style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
            ],
          ),
        ),
      ),
    );
  }
}