import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entity/water_log_entity.dart';
import '../models/models.dart';

class WaterRepository {
  WaterRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseAuth? fireabaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = fireabaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  bool _isAuthenticated() => _firebaseAuth.currentUser != null;

  CollectionReference? _collRef() {
    if (_firebaseAuth.currentUser != null) {
      final String userId = _firebaseAuth.currentUser!.uid;

      return _firebaseFirestore.collection('users').doc(userId).collection('water_tracking');
    }
    return null;
  }

  Future<List<WaterLog>?> getWaterLogHistory() async {
    if (_isAuthenticated()) {
      QuerySnapshot snapshot = await _collRef()!.get();

      return snapshot.docs.map((e) {
        final WaterLogEntity entity = WaterLogEntity.fromDocumentSnapshot(e);

        return WaterLog.fromEntity(entity);
      }).toList();
    }

    return null;
  }
}
