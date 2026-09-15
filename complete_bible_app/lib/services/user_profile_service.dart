import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class UserProfileService {
  UserProfileService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> saveProfile(String uid, UserProfile profile) {
    return _firestore
        .collection('users')
        .doc(uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Future<UserProfile?> getProfile(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null || (data['name'] as String?)?.isEmpty != false) {
      return null;
    }
    return UserProfile.fromMap(data);
  }

  Future<void> deleteProfile(String uid) {
    return _firestore.collection('users').doc(uid).delete();
  }
}
