import 'package:cloud_firestore/cloud_firestore.dart';

import 'entity/entity.dart';

class UserInfoRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserInfoRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream userInfo(String userId) {
    return _firebaseFirestore.doc(userId).snapshots().map((snap) => UserInfoEntity.fromDocumentSnapshot(snap));
  }
}
