// ignore_for_file: avoid_print

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safaritop/common/routes.dart';
import 'package:safaritop/providers/ads_provider.dart';
import 'package:safaritop/services/push_notification_service.dart';
import 'package:safaritop/utilities/colors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
      iOSAdvertiserTrackingEnabled: true //default false
      );

  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

// final BannerAd myBanner = BannerAd(
//   adUnitId: 'ca-app-pub-4327249955512978/5328768201',
//   size: AdSize.banner,
//   request: const AdRequest(),
//   listener: const BannerAdListener(),
// );

// final AdWidget adWidget = AdWidget(ad: myBanner);

class FacebookBannerAdOne extends StatelessWidget {
  const FacebookBannerAdOne({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FacebookBannerAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        switch (result) {
          case BannerAdResult.ERROR:
            print("Facebook Banner Error: $value");
            break;
          case BannerAdResult.LOADED:
            print("Facebook Banner Loaded: $value");
            break;
          case BannerAdResult.CLICKED:
            print("Facebook BannerClicked: $value");
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            print("Facebook Banner Logging Impression: $value");
            break;
        }
      },
    );
  }
}

Widget _nativeAd() {
  return FacebookNativeAd(
    placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964952163583650",
    adType: NativeAdType.NATIVE_AD_VERTICAL,
    width: double.infinity,
    height: 300,
    backgroundColor: Colors.blue,
    titleColor: Colors.white,
    descriptionColor: Colors.white,
    buttonColor: Colors.deepPurple,
    buttonTitleColor: Colors.white,
    buttonBorderColor: Colors.white,
    listener: (result, value) {
      print("Native Ad: $result --> $value");
    },
    keepExpandedWhileLoading: true,
    expandAnimationDuraion: 1000,
  );
}

void _loadInterstitialAd() {
  FacebookInterstitialAd.loadInterstitialAd(
    // placementId: "YOUR_PLACEMENT_ID",
    placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
    listener: (result, value) {
      print(">> FAN > Interstitial Ad: $result --> $value");
      if (result == InterstitialAdResult.LOADED)
      // _isInterstitialAdLoaded = true;

      /// Once an Interstitial Ad has been dismissed and becomes invalidated,
      /// load a fresh Ad by calling this function.
      // ignore: curly_braces_in_flow_control_structures
      if (result == InterstitialAdResult.DISMISSED &&
          value["invalidated"] == true) {
        // _isInterstitialAdLoaded = false;
        _loadInterstitialAd();
      }
    },
  );
}

Widget facebookNativeBannerAd() {
  return FacebookNativeAd(
    // placementId: "YOUR_PLACEMENT_ID",
    placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
    adType: NativeAdType.NATIVE_AD,
    bannerAdSize: const NativeBannerAdSize(height: 400),
    width: double.infinity,
    height: 250,
    backgroundColor: Colors.blue,
    titleColor: Colors.white,
    descriptionColor: Colors.white,
    buttonColor: Colors.deepPurple,
    buttonTitleColor: Colors.white,
    buttonBorderColor: Colors.white,
    listener: (result, value) {
      print("Native Banner Ad: $result --> $value");
    },
  );
}

Widget facebookBannerAd() {
  return FacebookBannerAd(
    // placementId: "YOUR_PLACEMENT_ID",
    placementId:
        "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047", //testid
    bannerSize: BannerSize.STANDARD,
    listener: (result, value) {
      print("Native Banner Ad: $result --> $value");
    },
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

late BannerAd myBannerAd;
late BannerAd bottomNavBarBanner;

class _MyAppState extends ConsumerState<MyApp> {
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  @override
  void initState() {
    super.initState();
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream;
    firebaseMessaging.bodyCtlr.stream;
    firebaseMessaging.titleCtlr.stream;
    ref.read(bottomNavAdProvider);
    ref.read(descirptionAdProvider);
    ref.read(openPostAdProvider);
    ref.read(postAdProvider);
    ref.read(titleAdProvider);
    ref.read(videoEndAdProvider);
    ref.read(videoStartAdProvider);
    myBannerAd = BannerAd(
      adUnitId: 'ca-app-pub-4327249955512978/5328768201',
      request: const AdRequest(),
      size: const AdSize(width: 300, height: 250),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        // onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );

    myBannerAd.load();
    bottomNavBarBanner = BannerAd(
      adUnitId: 'ca-app-pub-4327249955512978/5328768201',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        // onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );
    bottomNavBarBanner.load();
  }

  @override
  void dispose() {
    super.dispose();
    myBannerAd.dispose();
    // myBannerAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: goRouter.routeInformationProvider,
      routeInformationParser: goRouter.routeInformationParser,
      routerDelegate: goRouter.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'Safari Videos',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: whiteBackgroundColor,
          textTheme: GoogleFonts.montserratTextTheme(),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: blueColor03,
            unselectedItemColor: Colors.grey,
            backgroundColor: whiteBackgroundColor,
          )),
    );
  }
}
