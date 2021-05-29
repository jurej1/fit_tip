import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../entity/entity.dart';
import '../models/models.dart';

class WeightRepository {
  WeightRepository({FirebaseFirestore? firebaseFirestore, FirebaseAuth? firebaseAuth})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firebaseFirestore;

  //Aditional functions
  CollectionReference _weightTrackingRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('weight_tracking');
  }

  CollectionReference _weightGoalRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('goals');
  }

  DocumentReference _weightGoalDocRef(String userId) {
    return _weightGoalRef(userId).doc('weight');
  }

  Future<Weight> currentWeight(String userId) async {
    final snap = await _weightTrackingRef(userId).orderBy(DocKeysWeight.date, descending: true).limit(1).get();

    return Weight.fromEntity(WeightEntity.fromDocumentSnapshot(snap.docs.first));
  }

  //Weight tracking
  Future<List<Weight>> weightHistory(String userId) async {
    Query query = _weightTrackingRef(userId).orderBy(DocKeysWeight.date, descending: true);

    final snap = await query.get();

    return snap.docs.map((e) {
      final entity = WeightEntity.fromDocumentSnapshot(e);

      return Weight.fromEntity(entity);
    }).toList();
  }

  Future<DocumentReference> addWeight(String userId, Weight weight) async {
    return _weightTrackingRef(userId).add(weight.toEntity().toDocument());
  }

  Future<void> deleteWeight(String userId, String id) async {
    return _weightTrackingRef(userId).doc(id).delete();
  }

  Future<void> updateWeight(String userId, Weight weight) async {
    return _weightTrackingRef(userId).doc(weight.id).update(weight.toEntity().toDocument());
  }

  //Weight goals
  Future<WeightGoal?> getWeighGoal(String userId) async {
    final data = await _weightGoalDocRef(userId).get();

    return WeightGoal.fromEntity(WeightGoalEntity.fromDocumentSnapshot(data));
  }

  Future<void> updateWeightGoal(String userId, WeightGoal goal) async {
    return _weightGoalDocRef(userId).set(goal.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteWeightGoal(String userId) async {
    return _weightGoalDocRef(userId).delete();
  }

  //Weight statistics

  /// Calculates a weight change based on a certain duration
  double weightChangeOnDuration(List<Weight> weights, Duration duration) {
    if (weights.isEmpty) return 0;

    final currentDate = DateTime.now();
    final lowerBoundDate = currentDate.subtract(duration);

    final filteredWeights = weights.where((element) => element.date?.isAfter(lowerBoundDate) ?? false).toList();

    if (filteredWeights.isEmpty) return 0;

    final firstWeight = filteredWeights.first.weight ?? 0;
    final lastWeight = filteredWeights.last.weight ?? 0;

    double change = (firstWeight - lastWeight).toDouble();

    return change;
  }

  double totalWeightChange(List<Weight> weights) {
    final firstWeight = weights.first.weight ?? 0;
    final lastWeight = weights.last.weight ?? 0;

    num change = firstWeight - lastWeight;

    return change.toDouble();
  }

  double remaining(double currentWeight, double goalWeight) {
    return currentWeight - goalWeight;
  }

  ///Returns the percantage of how many progress was done in the whole time period from 0 to 1
  double progressPercantage({
    required double current,
    required double starting,
    required double target,
  }) {
    double diff = target - starting;
    if (diff.isNegative) diff = diff * (-1);
    double amountDone = starting - current;
    if (amountDone.isNegative) amountDone = amountDone * (-1);
    return amountDone / diff;
  }
}
