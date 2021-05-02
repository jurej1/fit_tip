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

  String? get userId => _firebaseAuth.currentUser?.uid;
  CollectionReference _collectionRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('weight_tracking');
  }

  Future<Weight?> get currentWeight async {
    if (userId == null) return null;

    final snap = await _collectionRef(userId!).orderBy(DocKeysWeight.date, descending: true).limit(1).get();

    return Weight.fromEntity(WeightEntity.fromDocumentSnapshot(snap.docs.first));
  }

  Future<List<Weight>?> weightHistory() async {
    if (userId == null) return null;

    Query query = _collectionRef(userId!).orderBy(DocKeysWeight.date, descending: true);

    final snap = await query.get();

    return snap.docs.map((e) {
      final entity = WeightEntity.fromDocumentSnapshot(e);

      return Weight.fromEntity(entity);
    }).toList();
  }

  Future<DocumentReference?> addWeight(Weight weight) async {
    if (userId == null) return null;
    return _collectionRef(userId!).add(weight.copyWith(dateAdded: DateTime.now()).toEntity().toDocument());
  }

  Future<void> deleteWeight(String id) async {
    if (userId == null) return;
    return _collectionRef(userId!).doc(id).delete();
  }

  Future<void> updateWeight(Weight weight) async {
    if (userId == null) return null;

    return _collectionRef(userId!).doc(weight.id).update(weight.toEntity().toDocument());
  }
}
