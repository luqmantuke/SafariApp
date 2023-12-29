// ignore_for_file: avoid_print

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:safaritop/common/routes.dart';
import 'package:safaritop/common/sizeConfig.dart';
import 'package:safaritop/common/video_player_widget.dart';
import 'package:safaritop/main.dart';
import 'package:safaritop/models/post_model.dart';
import 'package:safaritop/providers/ads_provider.dart';

class DetailsPage extends ConsumerStatefulWidget {
  PostModel post;
  DetailsPage({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailsPageState();
}

late BannerAd titleBannerAd;
late BannerAd descriptionBannerAd;

class _DetailsPageState extends ConsumerState<DetailsPage> {
  RewardedAd? _rewardedAd;

  // TODO: Implement _loadRewardedAd()
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-4327249955512978/9990524796',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    titleBannerAd = BannerAd(
      adUnitId: 'ca-app-pub-4327249955512978/3908332170',
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {},
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        // onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );

    titleBannerAd.load();
    descriptionBannerAd = BannerAd(
      adUnitId: 'ca-app-pub-4327249955512978/4071983705',
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {},
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        // onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );
    descriptionBannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    titleBannerAd.dispose();
    descriptionBannerAd.dispose();
    _rewardedAd?.dispose();
    // myBannerAd = null;
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavAd = ref.watch(bottomNavAdProvider);
    final descirptionAd = ref.watch(descirptionAdProvider);
    final openPostAd = ref.watch(openPostAdProvider);
    final postAd = ref.watch(postAdProvider);
    final titleAd = ref.watch(titleAdProvider);
    final videoEndAd = ref.watch(videoEndAdProvider);
    final videoStartAd = ref.watch(videoStartAdProvider);
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          leading: videoEndAd.maybeWhen(
              orElse: (() => const SizedBox()),
              data: (data) {
                bool fb = data.docs[0].get('facebook');
                bool google = data.docs[0].get('google');
                return fb == true
                    ? InkWell(
                        onTap: () {
                          FacebookInterstitialAd.loadInterstitialAd(
                            placementId:
                                "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
                            listener: (result, value) {
                              if (result == InterstitialAdResult.LOADED) {
                                FacebookInterstitialAd.showInterstitialAd(
                                    delay: 5000);
                              }
                            },
                          ).then((value) => goRouter.pop());

                          goRouter.pop();
                        },
                        child: const Icon(FontAwesomeIcons.arrowLeft))
                    : InkWell(
                        onTap: () {
                          _rewardedAd
                              ?.show(
                                  onUserEarnedReward: ((ad, reward) =>
                                      goRouter.pop()))
                              .then((value) => goRouter.pop());

                          goRouter.pop();
                        },
                        child: const Icon(FontAwesomeIcons.arrowLeft));
              }),
          backgroundColor: Colors.white,
          title: const Text("",
              style: TextStyle(
                color: Colors.black,
              )),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.post.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight(context) * 0.02),
              Container(
                alignment: Alignment.center,
                width: titleBannerAd.size.width.toDouble(),
                height: titleBannerAd.size.height.toDouble(),
                child: StatefulBuilder(builder: (context, setState) {
                  final AdWidget adWidget = AdWidget(ad: titleBannerAd);
                  return titleAd.maybeWhen(
                      orElse: () => const SizedBox(),
                      data: (data) {
                        bool fb = data.docs[0].get('facebook');
                        bool google = data.docs[0].get('google');
                        return fb == true ? facebookNativeBannerAd() : adWidget;
                      });
                }),
              ),
              SizedBox(height: SizeConfig.screenHeight(context) * 0.02),
              widget.post.video == ''
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        print("outside");

                        // _rewardedAd?.show(
                        //     onUserEarnedReward: ((ad, rewarded) {}));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () {
                            print("inside");
                            // _rewardedAd?.show(
                            //     onUserEarnedReward: ((ad, rewarded) {}));
                          },
                          child: VideoScreen(
                            url: widget.post.video,
                            thumbnail: widget.post.image,
                            autoplay: false,
                            rewardedAd: _rewardedAd,
                          ),
                        ),
                      ),
                    ),
              Container(
                alignment: Alignment.center,
                width: descriptionBannerAd.size.width.toDouble(),
                height: descriptionBannerAd.size.height.toDouble(),
                child: StatefulBuilder(builder: (context, setState) {
                  final AdWidget adWidget = AdWidget(ad: descriptionBannerAd);
                  return descirptionAd.maybeWhen(
                      orElse: () => const SizedBox(),
                      data: (data) {
                        bool fb = data.docs[0].get('facebook');
                        bool google = data.docs[0].get('google');
                        return fb == true ? facebookNativeBannerAd() : adWidget;
                      });
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Text(widget.post.description,
                    style: const TextStyle(
                      fontSize: 15,
                      letterSpacing: 1.5,
                    )),
              ),
            ]),
          ),
        ));
  }
}
