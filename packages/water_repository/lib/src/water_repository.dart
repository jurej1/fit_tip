import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_repository/entity/entity.dart';

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

  CollectionReference? _trackingRef() {
    if (_firebaseAuth.currentUser != null) {
      final String userId = _firebaseAuth.currentUser!.uid;

      return _firebaseFirestore.collection('users').doc(userId).collection('water_tracking');
    }
    return null;
  }

  CollectionReference? _infoRef() {
    if (_isAuthenticated()) {
      final String userId = _firebaseAuth.currentUser!.uid;

      return _firebaseFirestore.collection('users').doc(userId).collection('water_day_info');
    }

    return null;
  }

  CollectionReference? _goalRef() {
    if (_isAuthenticated()) {
      final String userId = _firebaseAuth.currentUser!.uid;

      return _firebaseFirestore.collection('users').doc(userId).collection('water_goals');
    }

    return null;
  }

  /// Returrns null if user unauthenticated
  Future<List<WaterLog>?> getWaterLogHistory() async {
    if (_isAuthenticated()) {
      QuerySnapshot snapshot = await _trackingRef()!.orderBy('date').get();

      return snapshot.docs.map((e) {
        final WaterLogEntity entity = WaterLogEntity.fromDocumentSnapshot(e);

        return WaterLog.fromEntity(entity);
      }).toList();
    }

    return null;
  }

  /// Returrns null if user unauthenticated
  Future<DocumentReference?> addWaterLog(WaterLog log) async {
    if (_isAuthenticated()) {
      return _trackingRef()!.add(log.toEntity().toDocumentSnapshot());
    }

    return null;
  }

  /// It does nothing if the user is unauthenticated
  Future<void> deleteWaterLog(WaterLog log) async {
    if (_isAuthenticated()) {
      return _trackingRef()!.doc(log.id).delete();
    }
  }

  /// It does not update if the user is unauthenticated
  Future<void> updateWaterLog(WaterLog log) async {
    if (_isAuthenticated()) {
      return _trackingRef()!.doc(log.id).update(log.toEntity().toDocumentSnapshot());
    }
  }

  /// Returrns null if user unauthenticated
  Future<List<WaterLog>?> getWaterLogForDay(DateTime date) async {
    if (_isAuthenticated()) {
      final upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);
      final lowerBound = DateTime(date.year, date.month, date.day, 0, 0, 0);

      QuerySnapshot snapshot = await _trackingRef()!
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

    return null;
  }

  /// Returrns null if user unauthenticated
  Future<List<WaterLog>?> getWaterLogForCertainTimePeriod(DateTime lowerBound, DateTime upperBound) async {
    if (_isAuthenticated()) {
      final upperBoundDate = DateTime(upperBound.year, upperBound.month, upperBound.day, 23, 59, 59);
      final lowerBoundDate = DateTime(lowerBound.year, lowerBound.month, lowerBound.day, 0, 0, 0);

      QuerySnapshot snapshot = await _trackingRef()!
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

    return null;
  }

  /// Returrns null if user unauthenticated
  Future<WaterDailyInfo?> getWaterTrackingDayInfo(DateTime date) async {
    if (_isAuthenticated()) {
      final lowerBound = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot snapshot = await _infoRef()!.where('date', isGreaterThan: lowerBound, isLessThan: upperBound).limit(1).get();

      return snapshot.docs.map((e) => WaterDailyInfo.fromEntity(WaterDailyInfoEntity.fromDocumentSnapshot(e))).toList().first;
    }

    return null;
  }

  /// Returrns null if user unauthenticated
  Future<WaterDailyGoal?> getCurrentWaterGoal(WaterDailyGoal? goal) async {
    if (_isAuthenticated()) {
      DateTime date = goal?.date ?? DateTime.now();
      String id = WaterGoalDailyEntity.generateId(date);

      DocumentSnapshot snap = await _goalRef()!.doc(id).get();

      if (!snap.exists) {
        date = date.subtract(Duration(days: 1));
        id = WaterGoalDailyEntity.generateId(date);
        snap = await _goalRef()!.doc(id).get();
      }
      WaterGoalDailyEntity entity = WaterGoalDailyEntity.fromDocumentSnapshot(snap);
      return WaterDailyGoal.fromEntity(entity).copyWith(date: DateTime.now());
    }
  }

  /// Does nothing if user unauthenticated
  Future<void> addWaterGoal(WaterDailyGoal goal) async {
    if (_isAuthenticated()) {
      String id = WaterGoalDailyEntity.generateId(goal.date);
      return _goalRef()!.doc(id).set(goal.toEntity().toDocumentSnapshot());
    }
  }

  /// Does nothing if user unauthenticated
  Future<void> deleteWaterGoal(WaterDailyGoal goal) async {
    if (_isAuthenticated()) {
      String id = WaterGoalDailyEntity.generateId(goal.date);
      return _goalRef()!.doc(id).delete();
    }
  }

  /// Does nothing if user unauthenticated
  Future<void> updateWaterGoal(WaterDailyGoal goal) async {
    if (_isAuthenticated()) {
      String id = WaterGoalDailyEntity.generateId(goal.date);
      return _goalRef()!.doc(id).set(
            goal.toEntity().toDocumentSnapshot(),
            SetOptions(merge: true),
          );
    }
  }
}
