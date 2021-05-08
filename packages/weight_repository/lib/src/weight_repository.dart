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

  //Aditional functions

  String? get userId => _firebaseAuth.currentUser?.uid;
  CollectionReference _weightTrackingRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('weight_tracking');
  }

  CollectionReference _weightGoalRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('goals');
  }

  DocumentReference _weightGoalDocRef(String userId) {
    return _weightGoalRef(userId).doc('weight');
  }

  Future<Weight?> get currentWeight async {
    if (userId == null) return null;

    final snap = await _weightTrackingRef(userId!).orderBy(DocKeysWeight.date, descending: true).limit(1).get();

    return Weight.fromEntity(WeightEntity.fromDocumentSnapshot(snap.docs.first));
  }

  //Weight tracking
  Future<List<Weight>?> weightHistory() async {
    if (userId == null) return null;

    Query query = _weightTrackingRef(userId!).orderBy(DocKeysWeight.date, descending: true);

    final snap = await query.get();

    return snap.docs.map((e) {
      final entity = WeightEntity.fromDocumentSnapshot(e);

      return Weight.fromEntity(entity);
    }).toList();
  }

  Future<DocumentReference?> addWeight(Weight weight) async {
    if (userId == null) return null;

    return _weightTrackingRef(userId!).add(weight.toEntity().toDocument());
  }

  Future<void> deleteWeight(String id) async {
    if (userId == null) return;
    return _weightTrackingRef(userId!).doc(id).delete();
  }

  Future<void> updateWeight(Weight weight) async {
    if (userId == null) return null;

    return _weightTrackingRef(userId!).doc(weight.id).update(weight.toEntity().toDocument());
  }

  //Weight goals
  Future<WeightGoal?> getWeighGoal() async {
    if (userId == null) {
      return null;
    }
    final data = await _weightGoalDocRef(userId!).get();

    return WeightGoal.fromEntity(WeightGoalEntity.fromDocumentSnapshot(data));
  }

  Future<void> updateWeightGoal(WeightGoal goal) async {
    if (userId == null) {
      return null;
    }

    return _weightGoalDocRef(userId!).update(goal.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteWeightGoal() async {
    if (userId == null) return null;
    return _weightGoalDocRef(userId!).delete();
  }

  //Weight statistics

  double last7DaysChange(List<Weight> weights) {
    final currentDate = DateTime.now();
    final lowerBoundDate = currentDate.subtract(const Duration(days: 7));
    final recentWeights = weights.where((element) => element.date?.isAfter(lowerBoundDate) ?? false).toList();

    final firstWeight = recentWeights.first.weight ?? 0;
    final lastWeight = recentWeights.last.weight ?? 0;

    num change = firstWeight - lastWeight;

    return change.toDouble();
  }

  double last30DaysChange(List<Weight> weights) {
    final currentDate = DateTime.now();
    final lowerBoundDate = currentDate.subtract(const Duration(days: 30));
    final recentWeights = weights.where((element) => element.date?.isAfter(lowerBoundDate) ?? false).toList();

    final firstWeight = recentWeights.first.weight ?? 0;
    final lastWeight = recentWeights.last.weight ?? 0;

    num change = firstWeight - lastWeight;

    return change.toDouble();
  }

  double totalWeightChange(List<Weight> weights) {
    final firstWeight = weights.first.weight ?? 0;
    final lastWeight = weights.last.weight ?? 0;

    num change = firstWeight - lastWeight;

    return change.toDouble();
  }
}
