import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/main.dart';
import 'package:iskai/services/databaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  DatabaseService _dbService = new DatabaseService();

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await _dbService.updateProcessOfAchievement(1, 1);
    if (result.success && result.unlocked) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Achievement is unlock')));
      
    } else if (!result.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка в достижении')));
    }

    await prefs.setBool('onboardingShown', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Iskai')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<OnBoard> data = [
      OnBoard(
        image: './assets/imgs/onboardingScreen1.png',
        text1: AppLocalizations.of(context)!.onboardingTitle1,
        text2: AppLocalizations.of(context)!.onboardingSubtitle1,
      ),
      OnBoard(
        image: './assets/imgs/onboardingScreen2.png',
        text1: AppLocalizations.of(context)!.onboardingTitle2,
        text2: AppLocalizations.of(context)!.onboardingSubtitle2,
      ),
      OnBoard(
        image: './assets/imgs/onboardingScreen3.png',
        text1: AppLocalizations.of(context)!.onboardingTitle3,
        text2: AppLocalizations.of(context)!.onboardingSubtitle3,
      ),
      OnBoard(
        image: './assets/imgs/onboardingScreen4.png',
        text1: AppLocalizations.of(context)!.onboardingTitle4,
        text2: AppLocalizations.of(context)!.onboardingSubtitle4,
      ),
      OnBoard(
        image: './assets/imgs/onboardingScreen5.png',
        text1: AppLocalizations.of(context)!.onboardingTitle5,
        text2: AppLocalizations.of(context)!.onboardingSubtitle5,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    itemCount: data.length,
                    itemBuilder: (context, index) => OnBoardContent(
                      image: data[index].image,
                      text1: data[index].text1,
                      text2: data[index].text2,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ...List.generate(
                        data.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: DotIndicator(isActive: index == _pageIndex),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_pageIndex == data.length - 1) {
                              _completeOnboarding(context);
                            } else {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          },
                          child: _pageIndex == data.length - 1
                              ? Icon(Icons.check)
                              : ImageIcon(
                                  size: 25,
                                  AssetImage('./assets/imgs/right_arrow.png'),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 15,
              right: 15,
              child: TextButton(
                child: Text(AppLocalizations.of(context)!.skipBtn),
                onPressed: () {
                  _completeOnboarding(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: Colors.green[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class OnBoard {
  final String image, text1, text2;
  OnBoard({required this.image, required this.text1, required this.text2});
}

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.image,
    required this.text1,
    required this.text2,
  });

  final String image, text1, text2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.asset(image),
                    ),
                    Text(
                      text1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      text2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
