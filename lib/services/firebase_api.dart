import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  final _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchAllPosts() {
    return _db.collection('posts').snapshots();
  }

  Stream<QuerySnapshot> fetchAnimalPosts() {
    return _db
        .collection('posts')
        .where('type', isEqualTo: 'animals')
        .snapshots();
  }

  Stream<QuerySnapshot> fetchFunnyPosts() {
    return _db
        .collection('posts')
        .where('type', isEqualTo: 'funny')
        .snapshots();
  }

  Stream<QuerySnapshot> fetchLovePosts() {
    return _db.collection('posts').where('type', isEqualTo: 'love').snapshots();
  }

  Stream<QuerySnapshot> fetchFitnessPosts() {
    return _db
        .collection('posts')
        .where('type', isEqualTo: 'fitness')
        .snapshots();
  }

  Future<void> addPost(String title, String description, String video,
      String type, String image) {
    return _db.collection('posts').add({
      "title": title,
      'description': description,
      'video': video,
      'type': type,
      'image': image
    });
  }

  Future<void> updatePost(String postId, String title, String description,
      String video, String type, String image) {
    return _db.collection('posts').doc(postId).update({
      "title": title,
      'description': description,
      'video': video,
      'type': type,
      'image': image
    });
  }

  Future<void> deletePost(String postId) {
    return _db.collection('posts').doc(postId).delete();
  }

  Stream<QuerySnapshot> streamPosts() {
    return _db.collection('posts').snapshots();
  }

  Stream<QuerySnapshot> streamBottomNavAds() {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('bottomNavBarAd')
        .snapshots();
  }

  Future<void> toggleBottomNavAds(bool facebook, bool google) async {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('bottomNavBarAd')
        .doc('A0sFL4AJARYc2cSHSyvv')
        .update({'facebook': facebook, 'google': google});
  }

  Stream<QuerySnapshot> streamDescriptionAds() {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('descirptionAd')
        .snapshots();
  }

  Future<void> toggleDescriptionAds(bool facebook, bool google) async {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('descirptionAd')
        .doc('CRVuJtMHwx9ktdmD4d1C')
        .update({'facebook': facebook, 'google': google});
  }

  Stream<QuerySnapshot> streamOpenPostAd() {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('openPostAd')
        .snapshots();
  }

  Future<void> toggleOpenPostAd(bool facebook, bool google) async {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('openPostAd')
        .doc('bgEzEReiVYxyVBJobXSF')
        .update({'facebook': facebook, 'google': google});
  }

  Stream<QuerySnapshot> streamPostAd() {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('postAd')
        .snapshots();
  }

  Future<void> togglePostAd(bool facebook, bool google) async {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('postAd')
        .doc('jciQXIcmzWb9uUDz0Ebg')
        .update({'facebook': facebook, 'google': google});
  }

  Stream<QuerySnapshot> streamTitleAd() {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('titleAd')
        .snapshots();
  }

  Future<void> toggleTitleAd(bool facebook, bool google) async {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('titleAd')
        .doc('P21DICADNzYCwMFODknT')
        .update({'facebook': facebook, 'google': google});
  }

  Stream<QuerySnapshot> streamVideoEndAd() {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('videoEndAd')
        .snapshots();
  }

  Future<void> toggleVideoEndAd(bool facebook, bool google) async {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('videoEndAd')
        .doc('jvAAfjS9uET9jxLIb0y0')
        .update({'facebook': facebook, 'google': google});
  }

  Stream<QuerySnapshot> streamVideoStartAd() {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('videoStartAd')
        .snapshots();
  }

  Future<void> toggleVideoStartAd(bool facebook, bool google) async {
    return _db
        .collection('ads')
        .doc('kvEAARo1cPZbRKJw64ug')
        .collection('videoStartAd')
        .doc('7P2oVbufyPYTord0Aik6')
        .update({'facebook': facebook, 'google': google});
  }
}
