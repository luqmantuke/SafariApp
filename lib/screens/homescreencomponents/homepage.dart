// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:safaritop/common/routes.dart';
import 'package:safaritop/common/sizeConfig.dart';
import 'package:safaritop/main.dart';
import 'package:safaritop/models/post_model.dart';
import 'package:safaritop/providers/ads_provider.dart';
import 'package:safaritop/utilities/colors.dart';

class HomePage extends ConsumerStatefulWidget {
  List<PostModel>? posts;

  HomePage({
    required this.posts,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  RewardedAd? _rewardedAd;

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
    debugPrint("ALL ${widget.posts?.length}");

    return Scaffold(
        backgroundColor: whiteBackgroundColor,
        body: ListView.separated(
            separatorBuilder: (context, index) {
              final Container adContainer = Container(
                alignment: Alignment.center,
                width: myBannerAd.size.width.toDouble(),
                height: myBannerAd.size.height.toDouble(),
                child: StatefulBuilder(builder: (context, setState) {
                  final AdWidget adWidget = AdWidget(ad: myBannerAd);

                  return adWidget;
                }),
              );

              if ((index + 1) % 2 == 0) {
                return postAd.maybeWhen(
                    orElse: () => const SizedBox(),
                    data: (data) {
                      bool fb = data.docs[0].get('facebook');
                      bool google = data.docs[0].get('google');
                      return fb == true
                          ? facebookNativeBannerAd()
                          : adContainer;
                    });
              } else {
                return Container();
              }
            },
            itemCount: widget.posts?.length ?? 0,
            itemBuilder: (context, index) {
              if (widget.posts!.isEmpty) {
                return const Center(
                  child: Text("No Posts"),
                );
              }
              return openPostAd.maybeWhen(
                  orElse: () => const SizedBox(),
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
                              ).then((value) => goRouter.push(
                                  '/post/${widget.posts![index].title}',
                                  extra: widget.posts![index]));

                              // _rewardedAd
                              //     ?.show(
                              //         onUserEarnedReward: ((ad, reward) => goRouter.push(
                              //             '/post/${widget.posts![index].title}',
                              //             extra: widget.posts![index])))
                              //     .then((value) => goRouter.push(
                              //         '/post/${widget.posts![index].title}',
                              //         extra: widget.posts![index]));
                              return goRouter.push(
                                  '/post/${widget.posts![index].title}',
                                  extra: widget.posts![index]);
                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          topLeft: Radius.circular(12),
                                        ),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              widget.posts![index].image,
                                            )),
                                      ),
                                      height: SizeConfig.screenHeight(context) *
                                          0.2,
                                      width: SizeConfig.screenWidth(context),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        widget.posts![index].title,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        "Yesterday",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          )
                        : InkWell(
                            onTap: () {
                              _rewardedAd
                                  ?.show(
                                      onUserEarnedReward: ((ad, reward) =>
                                          goRouter.push(
                                              '/post/${widget.posts![index].title}',
                                              extra: widget.posts![index])))
                                  .then((value) => goRouter.push(
                                      '/post/${widget.posts![index].title}',
                                      extra: widget.posts![index]));
                              return goRouter.push(
                                  '/post/${widget.posts![index].title}',
                                  extra: widget.posts![index]);
                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          topLeft: Radius.circular(12),
                                        ),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              widget.posts![index].image,
                                            )),
                                      ),
                                      height: SizeConfig.screenHeight(context) *
                                          0.2,
                                      width: SizeConfig.screenWidth(context),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        widget.posts![index].title,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        "Yesterday",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                  });
            }));
  }
}
