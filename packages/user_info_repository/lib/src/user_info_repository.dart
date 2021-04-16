import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserInfoRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream userInfo(String userId) {
    //TODO create a custom user info model
    return _firebaseFirestore.doc(userId).snapshots();
  }
}
