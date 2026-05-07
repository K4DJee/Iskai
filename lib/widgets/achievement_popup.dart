import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iskai/l10n/app_localizations.dart';

class AchievementPopup extends StatelessWidget {
  final String achievementName;
  const AchievementPopup({super.key, required this.achievementName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              // color: Color.fromRGBO(47, 47, 47, 0.45),//828282 //все было 234
              color: HexColor('#313131'),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 2,
                          fontFamily: 'RussoOne',
                          color: HexColor('#5BFF3B'),
                          // fontFamily:
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.achievementReceived,
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2,
                          fontFamily: 'RussoOne',
                          color: Colors.white,
                        ),
                        child: Text(achievementName),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: HexColor('#EAEAEA'),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/imgs/achievement-icon-1.png",
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
