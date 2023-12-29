import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:safaritop/common/my_app_bar.dart';
import 'package:safaritop/common/sizeConfig.dart';
import 'package:safaritop/main.dart';
import 'package:safaritop/models/post_model.dart';
import 'package:safaritop/providers/ads_provider.dart';
import 'package:safaritop/screens/homescreencomponents/animals_page.dart';
import 'package:safaritop/screens/homescreencomponents/fitness_page.dart';
import 'package:safaritop/screens/homescreencomponents/fun_videos_page.dart';
import 'package:safaritop/screens/homescreencomponents/homepage.dart';
import 'package:safaritop/screens/homescreencomponents/love_stories_page.dart';
import 'package:safaritop/services/firebase_api.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseApi().fetchAllPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final posts = snapshot.data?.docs
                .map((post) =>
                    PostModel.fromMap(post.data() as Map<String, dynamic>))
                .toList();
            return HomePage(
              posts: posts,
            );
          }
        }),
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseApi().fetchAnimalPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final posts = snapshot.data?.docs
                .map((post) =>
                    PostModel.fromMap(post.data() as Map<String, dynamic>))
                .toList();
            return AnimalsPage(
              posts: posts,
            );
          }
        }),
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseApi().fetchFunnyPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final posts = snapshot.data?.docs
                .map((post) =>
                    PostModel.fromMap(post.data() as Map<String, dynamic>))
                .toList();
            return FunVideosPage(
              posts: posts,
            );
          }
        }),
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseApi().fetchLovePosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final posts = snapshot.data?.docs
                .map((post) =>
                    PostModel.fromMap(post.data() as Map<String, dynamic>))
                .toList();
            return LoveStoriesPage(
              posts: posts,
            );
          }
        }),
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseApi().fetchFitnessPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final posts = snapshot.data?.docs
                .map((post) =>
                    PostModel.fromMap(post.data() as Map<String, dynamic>))
                .toList();
            return FitnessPage(
              posts: posts,
            );
          }
        }),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavAd = ref.watch(bottomNavAdProvider);

    return Scaffold(
      appBar: const MyAppBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: SizeConfig.screenHeight(context) * 0.15,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: StatefulBuilder(builder: (c, setState) {
                final AdWidget bottomAdWidget =
                    AdWidget(ad: bottomNavBarBanner);

                return Container(
                  alignment: const Alignment(0.5, 1),
                  child: bottomNavAd.maybeWhen(
                      orElse: () => const SizedBox(),
                      data: (data) {
                        bool fb = data.docs[0].get('facebook');
                        bool google = data.docs[0].get('google');
                        return fb == true ? facebookBannerAd() : bottomAdWidget;
                      }),
                );
              })),
              SizedBox(height: SizeConfig.screenHeight(context) * 0.01),
              BottomNavigationBar(
                // backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.houseChimneyUser),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.cat),
                    label: 'Animals',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.faceLaugh),
                    label: 'Fun videos',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.heartPulse),
                    label: 'Love Stories',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.dumbbell),
                    label: 'Fitness',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                showUnselectedLabels: true,
                // selectedIconTheme: IconThemeData(color: Colors.black),
                // unselectedIconTheme: IconThemeData(color: Colors.white),
                // selectedLabelStyle: TextStyle(color: Colors.black),
                // unselectedLabelStyle: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
