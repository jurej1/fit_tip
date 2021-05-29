import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_repository/entity/entity.dart';

import '../entity/water_log_entity.dart';
import '../models/models.dart';

class WaterRepository {
  WaterRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firebaseFirestore;

  CollectionReference _trackingRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('water_tracking');
  }

  CollectionReference _infoRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('water_day_info');
  }

  CollectionReference _goalRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('water_goals');
  }

  Future<List<WaterLog>> getWaterLogHistory(String userId) async {
    QuerySnapshot snapshot = await _trackingRef(userId).orderBy('date').get();

    return snapshot.docs.map((e) {
      final WaterLogEntity entity = WaterLogEntity.fromDocumentSnapshot(e);

      return WaterLog.fromEntity(entity);
    }).toList();
  }

  Future<DocumentReference?> addWaterLog(
    String userId,
    WaterLog log,
  ) async {
    return _trackingRef(userId).add(log.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteWaterLog(
    String userId,
    WaterLog log,
  ) async {
    return _trackingRef(userId).doc(log.id).delete();
  }

  Future<void> updateWaterLog(String userId, WaterLog log) async {
    return _trackingRef(userId).doc(log.id).update(log.toEntity().toDocumentSnapshot());
  }

  /// Returrns null if user unauthenticated
  Future<List<WaterLog>> getWaterLogForDay(String userId, DateTime date) async {
    final upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final lowerBound = DateTime(date.year, date.month, date.day, 0, 0, 0);

    QuerySnapshot snapshot = await _trackingRef(userId)
        .where('date', isGreaterThanOrEqualTo: lowerBound, isLessThanOrEqualTo: upperBound)
        .orderBy('date', descending: true)
        .get();

    if (snapshot.size == 0) {
      return [];
    } else {
      return snapshot.docs.map((e) {
        WaterLogEntity entity = WaterLogEntity.fromDocumentSnapshot(e);

        return WaterLog.fromEntity(entity);
      }).toList();
    }
  }

  /// Returrns null if user unauthenticated
  Future<List<WaterLog>> getWaterLogForCertainTimePeriod(String userId, DateTime lowerBound, DateTime upperBound) async {
    final upperBoundDate = DateTime(upperBound.year, upperBound.month, upperBound.day, 23, 59, 59);
    final lowerBoundDate = DateTime(lowerBound.year, lowerBound.month, lowerBound.day, 0, 0, 0);

    QuerySnapshot snapshot = await _trackingRef(userId)
        .where('date', isGreaterThanOrEqualTo: lowerBoundDate, isLessThanOrEqualTo: upperBoundDate)
        .orderBy('date', descending: true)
        .get();

    if (snapshot.size == 0) {
      return [];
    } else {
      return snapshot.docs.map((e) {
        WaterLogEntity entity = WaterLogEntity.fromDocumentSnapshot(e);

        return WaterLog.fromEntity(entity);
      }).toList();
    }
  }

  /// Returrns null if user unauthenticated
  Future<WaterDailyInfo> getWaterTrackingDayInfo(String userId, DateTime date) async {
    final lowerBound = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);

    QuerySnapshot snapshot = await _infoRef(userId).where('date', isGreaterThan: lowerBound, isLessThan: upperBound).limit(1).get();

    return snapshot.docs.map((e) => WaterDailyInfo.fromEntity(WaterDailyInfoEntity.fromDocumentSnapshot(e))).toList().first;
  }

  Future<WaterDailyGoal> getWaterDailyGoal(String userId, {required DateTime date}) async {
    String documentId = WaterGoalDailyEntity.generateId(date);

    DocumentSnapshot snap = await _goalRef(userId).doc(documentId).get();

    if (snap.exists) {
      return WaterDailyGoal.fromEntity(WaterGoalDailyEntity.fromDocumentSnapshot(snap));
    } else {
      QuerySnapshot querySnap = await _goalRef(userId).orderBy('date', descending: true).limit(1).get();

      if (querySnap.size == 0) {
        WaterDailyGoal goal = WaterDailyGoal(amount: 2300, id: documentId, date: date);
        addWaterGoal(userId, goal);

        return goal;
      } else {
        WaterDailyGoal goal = WaterDailyGoal.fromEntity(WaterGoalDailyEntity.fromDocumentSnapshot(querySnap.docs.first));

        goal = goal.copyWith(date: date, id: documentId);

        addWaterGoal(userId, goal);

        return goal;
      }
    }
  }

  /// Does nothing if user unauthenticated
  Future<void> addWaterGoal(String userId, WaterDailyGoal goal) async {
    String documentId = WaterGoalDailyEntity.generateId(goal.date);
    return _goalRef(userId).doc(documentId).set(goal.toEntity().toDocumentSnapshot());
  }

  /// Does nothing if user unauthenticated
  Future<void> deleteWaterGoal(String userId, WaterDailyGoal goal) async {
    String documentId = WaterGoalDailyEntity.generateId(goal.date);
    return _goalRef(userId).doc(documentId).delete();
  }

  /// Does nothing if user unauthenticated
  Future<void> updateWaterGoal(String userId, WaterDailyGoal goal) async {
    String id = WaterGoalDailyEntity.generateId(goal.date);
    return _goalRef(userId).doc(id).set(
          goal.toEntity().toDocumentSnapshot(),
          SetOptions(merge: true),
        );
  }
}
