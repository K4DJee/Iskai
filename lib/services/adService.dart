import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class AdService {
    BannerAdSize getAdSize(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width.round();
    return BannerAdSize.sticky(width: screenWidth);
  }

  late BannerAd banner;
  var isBannerAlreadyCreated = false;

  void loadAd(BuildContext context, Function setState) async {
    try {
      banner = _createBanner(context);
      await banner.loadAd();
      if (context.mounted) {
        setState(() {
          isBannerAlreadyCreated = true;
        });
      }
    } catch (e) {
      print('Error loading ad: $e');
      if (context.mounted) {
        setState(() {
          isBannerAlreadyCreated = false;
        });
      }
    }
  }

  _createBanner(BuildContext context){
    return BannerAd(
      adUnitId: 'R-M-18399243-1',
       adSize: getAdSize(context),
       adRequest: const AdRequest(),
       onAdLoaded: (){
        print('YandexAds OnLoaded');
        if(!context.mounted){
          banner.destroy();
          return;
        }
       },
      onAdFailedToLoad: (e){
        print('YandexAds OAdToFailedToLoad');
      },
      onAdClicked: (){
        print('YandexAds OnAdClicked');
      },
      onLeftApplication: (){
        print('YandexAds onLeftApplication');
      },
      onReturnedToApplication: (){
        print('YandexAds onReturnedToApplication');
      },
      onImpression: (ImpressionData){
        print('YandexAds OnImpression: ${ImpressionData.getRawData()}');
      },
      );
  }

  Widget? getAdWidget() {
    return isBannerAlreadyCreated
        ? AdWidget(bannerAd: banner)
        : null;
  }

  void dispose() {
    banner.destroy();
  }
}