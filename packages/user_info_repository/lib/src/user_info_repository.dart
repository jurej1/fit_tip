import 'package:cloud_firestore/cloud_firestore.dart';

import 'entity/entity.dart';
import 'models/models.dart';

class UserInfoRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserInfoRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<UserInfo>? userInfo(String? userId) {
    if (userId == null) return null;

    return _firebaseFirestore.doc(userId).snapshots().map((snap) => UserInfo.fromEntity(UserInfoEntity.fromDocumentSnapshot(snap)));
  }
}
