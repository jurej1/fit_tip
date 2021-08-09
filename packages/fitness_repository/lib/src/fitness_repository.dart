import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'entity/entity.dart';
import 'enums/enums.dart';
import 'models/models.dart';

class FitnessRepository {
  final FirebaseFirestore _firebaseFirestore;

  FitnessRepository({FirebaseFirestore? firebaseFirestore}) : this._firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  CollectionReference _activityTrackingRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('activity_tracking');
  }

  CollectionReference _activityGoalRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('activity_goal_tracking');
  }

  CollectionReference _fitnessTrackingPlanRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('fitness_tracking_plan');
  }

  CollectionReference _fitnessTrackingWorkoutRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('fitness_tracking_workouts');
  }

  Future<void> deleteExcerciseLog(String userId, ExcerciseLog log) {
    return _activityTrackingRef(userId).doc(log.id).delete();
  }

  Future<DocumentReference> addExcerciseLog(String userId, ExcerciseLog log) {
    return _activityTrackingRef(userId).add(log.toEntity().toDocumentSnapshot());
  }

  Future<void> updateExcerciseLog(String userId, ExcerciseLog log) {
    return _activityTrackingRef(userId).doc(log.id).update(log.toEntity().toDocumentSnapshot());
  }

  Future<QuerySnapshot> getExcerciseLogsForDay(String userId, DateTime date) {
    final lowerBound = DateTime(date.year, date.month, date.day);
    final upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _activityTrackingRef(userId)
        .orderBy('startTime', descending: true)
        .where('startTime', isGreaterThan: lowerBound, isLessThan: upperBound)
        .get();
  }

  Future<QuerySnapshot> getExcerciseLogsByExcerciseType(String userId, ExcerciseType type) {
    return _activityTrackingRef(userId).where('type', isEqualTo: describeEnum(type)).get();
  }

  /// If the document does exist ist will just overwrite the date
  Future<void> addExcerciseDailyGoal(String userId, ExcerciseDailyGoal goal) {
    return _activityGoalRef(userId).doc(goal.id).set(goal.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteExcerciseDailyGoal(String userId, ExcerciseDailyGoal goal) {
    return _activityGoalRef(userId).doc(goal.id).delete();
  }

  Future<ExcerciseDailyGoal> getExcerciseDailyGoal(String userId, DateTime date) async {
    final lowerBound = DateTime(date.year, date.month, date.day);
    final upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);

    QuerySnapshot querySnapshot =
        await _activityGoalRef(userId).where('date', isGreaterThanOrEqualTo: lowerBound, isLessThanOrEqualTo: upperBound).limit(1).get();

    if (querySnapshot.size == 1) {
      return ExcerciseDailyGoal.fromEntity(ExcerciseDailyGoalEntity.fromDocumentSnapshot(querySnapshot.docs.first));
    } else {
      querySnapshot = await _activityGoalRef(userId).where('date', isLessThan: lowerBound).limit(1).get();

      if (querySnapshot.size == 1) {
        final goal = ExcerciseDailyGoal.fromEntity(ExcerciseDailyGoalEntity.fromDocumentSnapshot(querySnapshot.docs.first));

        addExcerciseDailyGoal(userId, goal);
        return goal;
      }

      return ExcerciseDailyGoal();
    }
  }

  Future<void> deleteWorkout(String userId, Workout workout) {
    return _fitnessTrackingPlanRef(userId).doc(workout.id).delete();
  }

  Future<void> updateWorkout(String userId, Workout workout) {
    return _fitnessTrackingPlanRef(userId).doc(workout.id).update(workout.toEntity().toDocumentSnapshot());
  }

  Future<DocumentReference> addWorkout(String userId, Workout workout) async {
    return _fitnessTrackingPlanRef(userId).add(workout.toEntity().toDocumentSnapshot());
  }

  Future<QuerySnapshot> getWorkouts(String userId) {
    return _fitnessTrackingPlanRef(userId).get();
  }

  Future<Workout> setWorkoutAsActive(String userId, Workout workout) async {
    QuerySnapshot snapshot = await _fitnessTrackingPlanRef(userId).where('isActive', isEqualTo: true).get();

    List<Workout> workouts = Workout.fromQuerySnapshot(snapshot);

    workouts.forEach((element) {
      _fitnessTrackingPlanRef(userId).doc(element.id).update({'isActive': false});
    });

    await _fitnessTrackingPlanRef(userId).doc(workout.id).update({'isActive': true});

    return workout.copyWith(isActive: true);
  }

  Future<DocumentReference> addWorkoutDayLog(String userId, WorkoutDayLog log) async {
    return _fitnessTrackingWorkoutRef(userId).add(log.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteWorkoutDayLog(String userId, WorkoutDayLog log) async {
    return _fitnessTrackingWorkoutRef(userId).doc(log.id).delete();
  }

  Future<void> updateWorkoutDayLog(String userId, WorkoutDayLog log) async {
    return _fitnessTrackingWorkoutRef(userId).doc(log.id).update(log.toEntity().toDocumentSnapshot());
  }
}
