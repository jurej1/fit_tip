import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../entity/entity.dart';
import '../models/models.dart';

class WeightRepository {
  WeightRepository({FirebaseFirestore? firebaseFirestore, FirebaseAuth? firebaseAuth})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  Future<Weight?> get currentWeight async {
    final userId = _firebaseAuth.currentUser?.uid;

    if (userId == null) return null;

    final snap = await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('weight_tracking')
        .orderBy('dateAdded', descending: true)
        .limit(1)
        .get();

    return Weight.fromEntity(WeightEntity.fromQuerySnapshot(snap));
  }
}
