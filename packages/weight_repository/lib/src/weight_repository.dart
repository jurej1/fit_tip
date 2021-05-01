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
  final int _limit = 12;

  String? get userId => _firebaseAuth.currentUser?.uid;

  Future<Weight?> get currentWeight async {
    if (userId == null) return null;

    final snap = await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('weight_tracking')
        .orderBy('dateAdded', descending: true)
        .limit(1)
        .get();

    return Weight.fromEntity(WeightEntity.fromDocumentSnapshot(snap.docs.first));
  }

  Future<dynamic> weightHistory() async {
    if (userId == null) return null;

    Query query = _firebaseFirestore.collection('users').doc(userId).collection('weight_tracking').orderBy('dateAdded', descending: true);

    final snap = await query.get();

    return snap.docs.map((e) {
      final entity = WeightEntity.fromDocumentSnapshot(e);

      return Weight.fromEntity(entity);
    }).toList();
  }

  Future<DocumentReference?> addWeight(Weight weight) async {
    if (userId == null) return null;
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('weight_tracking')
        .add(weight.copyWith(dateAdded: DateTime.now()).toEntity().toDocument());
  }

  Future<void> deleteWeight(String id) async {
    if (userId == null) return;
    return _firebaseFirestore.collection('users').doc(userId).collection('weight_tracking').doc(id).delete();
  }

  Future<void> updateWeight(Weight weight) async {
    if (userId == null) return null;

    return _firebaseFirestore.collection('users').doc(userId).collection('weight_tracking').doc(weight.id).update(
          weight.toEntity().toDocument(),
        );
  }
}
