import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safaritop/providers/firebase_api_provider.dart';

final bottomNavAdProvider = StreamProvider<QuerySnapshot>((ref) async* {
  yield* ref.read(firebaseApiProvider).streamBottomNavAds();
});

final descirptionAdProvider = StreamProvider<QuerySnapshot>((ref) async* {
  yield* ref.read(firebaseApiProvider).streamDescriptionAds();
});

final openPostAdProvider = StreamProvider<QuerySnapshot>((ref) async* {
  yield* ref.read(firebaseApiProvider).streamOpenPostAd();
});

final postAdProvider = StreamProvider<QuerySnapshot>((ref) async* {
  yield* ref.read(firebaseApiProvider).streamPostAd();
});

final titleAdProvider = StreamProvider<QuerySnapshot>((ref) async* {
  yield* ref.read(firebaseApiProvider).streamTitleAd();
});

final videoEndAdProvider = StreamProvider<QuerySnapshot>((ref) async* {
  yield* ref.read(firebaseApiProvider).streamVideoEndAd();
});

final videoStartAdProvider = StreamProvider<QuerySnapshot>((ref) async* {
  yield* ref.read(firebaseApiProvider).streamVideoStartAd();
});
