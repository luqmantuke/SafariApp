import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safaritop/services/firebase_api.dart';

final firebaseApiProvider = Provider<FirebaseApi>((ref) {
  return FirebaseApi();
});
