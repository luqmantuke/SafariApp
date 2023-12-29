import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:safaritop/utilities/colors.dart';

class VideoScreen extends StatefulWidget {
  final String url;
  final String thumbnail;
  final bool autoplay;
  RewardedAd? rewardedAd;
  VideoScreen(
      {Key? key,
      required this.url,
      required this.thumbnail,
      required this.autoplay,
      this.rewardedAd})
      : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late String url = widget.url;
  late String thumbnail = widget.thumbnail;
  late BetterPlayerController _betterPlayerController;
  final StreamController<bool> _placeholderStreamController =
      StreamController.broadcast();
  bool _showPlaceholder = true;
  @override
  void dispose() {
    _placeholderStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      fit: BoxFit.cover,
      aspectRatio: 1,
      placeholder: _buildVideoPlaceholder(),
      showPlaceholderUntilPlay: true,
      autoPlay: widget.autoplay,
      overlay: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: const EdgeInsets.all(5),
          child: const FlutterLogo(),
        ),
      ),
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enablePip: true,
        loadingWidget: const CircularProgressIndicator(),
        enableProgressText: false,
        enableSkips: false,
        controlBarColor: Colors.transparent,
        showControlsOnInitialize: false,
        progressBarPlayedColor: blueColor03,
        progressBarHandleColor: blueColor03,
        progressBarBufferedColor: blueColor03.withOpacity(0.2),
        playerTheme: BetterPlayerTheme.material,
        iconsColor: blueColor03,
      ),
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        widget.rewardedAd?.show(onUserEarnedReward: ((ad, rewarded) {}));
      }
      // if (event.betterPlayerEventType == BetterPlayerEventType.bufferingEnd) {
      //   // _betterPlayerController.pause();
      // widget.rewardedAd?.show(onUserEarnedReward: ((ad, rewarded) {
      //   // _betterPlayerController.play();
      // }));
      // }
      _betterPlayerController.isVideoInitialized() == true
          ? widget.rewardedAd?.show(onUserEarnedReward: ((ad, rewarded) {
              // _betterPlayerController.play();
            }))
          : null;
      if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        _setPlaceholderVisibleState(false);
      }
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        _betterPlayerController.setOverriddenAspectRatio(
            _betterPlayerController.videoPlayerController!.value.aspectRatio);
        setState(() {});
      }
    });
    super.initState();
  }

  Widget _buildVideoPlaceholder() {
    return StreamBuilder<bool>(
      stream: _placeholderStreamController.stream,
      builder: (context, snapshot) {
        return _showPlaceholder
            ? Image.network(
                thumbnail,
                fit: BoxFit.cover,
              )
            : const SizedBox();
      },
    );
  }

  void _setPlaceholderVisibleState(bool hidden) {
    _placeholderStreamController.add(hidden);
    _showPlaceholder = hidden;
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(
      controller: _betterPlayerController,
    );
  }
}
