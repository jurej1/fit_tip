import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_repository/src/entity/workout_info_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'entity/entity.dart';
import 'enums/enums.dart';
import 'models/models.dart';

class FitnessRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Box<String?> _activeWorkoutIdsBox;
  final Box<List<String>> _savedWorkoutIdsBox;
  final Box<List<String>> _likedWorkoutIdsBox;

  FitnessRepository({
    FirebaseFirestore? firebaseFirestore,
    required Box<String?> activeWorkoutIdsBox,
    required Box<List<String>> savedWorkoutIdsBox,
    required Box<List<String>> likedWorkoutIdsBox,
  })  : this._firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        this._likedWorkoutIdsBox = likedWorkoutIdsBox,
        this._activeWorkoutIdsBox = activeWorkoutIdsBox,
        this._savedWorkoutIdsBox = savedWorkoutIdsBox;

  CollectionReference _activityTrackingRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('activity_tracking');
  }

  CollectionReference _activityGoalRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('activity_goal_tracking');
  }

  CollectionReference _fitnessTrackingPlanRef() {
    return _firebaseFirestore.collection('fitness_tracking_plans');
  }

  CollectionReference _activeFitnessPlanRef(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).collection('active_fitness_plan');
  }

  DocumentReference _fitnessTrackingPlanWorkoutDaysRef(String workoutId) {
    return _fitnessTrackingPlanRef().doc(workoutId).collection('data').doc('workout_days');
  }

  CollectionReference _fitnessTrackingWorkoutLogsRef() {
    return _firebaseFirestore.collection('fitness_tracking_workout_logs');
  }

//EXCERCISE FUNCTIONS
///////////////////////////////////////////////////////////////////

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

  //FITNESS WORKOUTS
///////////////////////////////////////////////////////////////////

  Stream<BoxEvent> savedWorkoutIdsStream(String userId) {
    return _savedWorkoutIdsBox.watch(key: userId);
  }

  List<String> getSavedWorkoutIds(String userId) {
    return _savedWorkoutIdsBox.get(userId, defaultValue: [])!;
  }

  Future<void> _updateSavedWorkoutIdsList(String userId, List<String> workoutIds) {
    return _savedWorkoutIdsBox.put(userId, workoutIds);
  }

  Future<void> addSavedWorkoutId(String userId, String workoutId) async {
    List<String> ids = getSavedWorkoutIds(userId);
    ids.add(workoutId);
    return _updateSavedWorkoutIdsList(userId, ids);
  }

  Future<void> removeSavedWorkoutId(String userId, String workoutId) async {
    List<String> ids = getSavedWorkoutIds(userId);
    ids.remove(workoutId);
    return _updateSavedWorkoutIdsList(userId, ids);
  }

  Stream<BoxEvent> likedWorkoutIdsStream(String userId) {
    return _likedWorkoutIdsBox.watch(key: userId);
  }

  List<String> getLikedWorkoutIds(String userId) {
    return _likedWorkoutIdsBox.get(userId, defaultValue: [])!;
  }

  Future<void> _updateLikedWorkoutIdsList(String userId, List<String> values) {
    return _likedWorkoutIdsBox.put(userId, values);
  }

  Future<void> likeWorkout(String workoutId, [bool isDownvote = false]) async {
    return _fitnessTrackingPlanRef().doc(workoutId).update({WorkoutInfoDocKeys.likes: FieldValue.increment(isDownvote ? -1 : 1)});
  }

  Future<void> addLikedWorkoutId(String userId, String workoutId) async {
    List<String> ids = getLikedWorkoutIds(userId);
    ids.add(workoutId);
    return _updateLikedWorkoutIdsList(userId, ids);
  }

  Future<void> removedLikedWorkoutId(String userId, String workoutId) {
    List<String> ids = getLikedWorkoutIds(userId);
    ids.remove(workoutId);
    return _updateLikedWorkoutIdsList(userId, ids);
  }

  Future<void> _setActiveWorkoutId(String userId, String workoutId) async {
    return _activeWorkoutIdsBox.put(userId, workoutId);
  }

  String? getActiveWorkoutId(String userId) {
    return _activeWorkoutIdsBox.get(userId, defaultValue: null);
  }

  Future<ActiveWorkout> setWorkoutAsActiveFromId(String userId, String id) async {
    List<DocumentSnapshot> snapshots = await Future.wait<DocumentSnapshot>([
      _fitnessTrackingPlanRef().doc(id).get(GetOptions(source: Source.cache)),
      _fitnessTrackingPlanWorkoutDaysRef(id).get(GetOptions(source: Source.cache)),
    ]);

    WorkoutInfo info = WorkoutInfo.fromEntiy(WorkoutInfoEntity.fromDocumentSnapshot(snapshots.first));
    WorkoutDays days = WorkoutDays.fromEntity(WorkoutDaysEntity.fromDocumentSnapshot(snapshots.last));

    ActiveWorkout workout = ActiveWorkout(
      info: ActiveWorkoutInfo.fromInfo(info),
      workoutDays: days,
    );

    return _writeActiveWorkoutToFB(userId, workout);
  }

  Future<ActiveWorkout> setWorkoutAsActiveFromWorkoutInfo(String userId, WorkoutInfo info) async {
    DocumentSnapshot snapshot = await _fitnessTrackingPlanWorkoutDaysRef(info.id).get(GetOptions(source: Source.cache));

    WorkoutDays days = WorkoutDays.fromEntity(WorkoutDaysEntity.fromDocumentSnapshot(snapshot));

    ActiveWorkout workout = ActiveWorkout(
      info: ActiveWorkoutInfo.fromInfo(info),
      workoutDays: days,
    );

    return _writeActiveWorkoutToFB(userId, workout);
  }

  Future<ActiveWorkout> setWorkoutAsActiveFromWorkout(String userId, Workout workout) async {
    ActiveWorkout activeWorkout = ActiveWorkout(
      info: ActiveWorkoutInfo.fromInfo(workout.info),
      workoutDays: workout.workoutDays,
    );

    return _writeActiveWorkoutToFB(userId, activeWorkout);
  }

  Future<ActiveWorkout> _writeActiveWorkoutToFB(String userId, ActiveWorkout workout) async {
    _activeFitnessPlanRef(userId).doc(workout.info.id).set(workout.toEntity().toDocumentSnapshot());
    await _setActiveWorkoutId(userId, workout.info.id);
    return workout.copyWith(info: workout.info);
  }

  Future<DocumentSnapshot> getActiveWorkoutById(String userId, String workoutId) async {
    return _activeFitnessPlanRef(userId).doc(workoutId).get();
  }

  Future<QuerySnapshot> getActiveWorkouts(String userId, {required int limit, DocumentSnapshot? startAfterDocument}) async {
    Query query = _activeFitnessPlanRef(userId).limit(limit);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  Future<void> deleteWorkoutById(String workoutId) {
    return _fitnessTrackingPlanRef().doc(workoutId).delete();
  }

  Future<void> updateWorkoutInfo(WorkoutInfo info) {
    return _fitnessTrackingPlanRef().doc(info.id).update(info.toEntity().toDocumentSnapshot());
  }

  Future<void> updateWorkoutDays(WorkoutDays days) {
    return _fitnessTrackingPlanWorkoutDaysRef(days.workoutId).update(days.toEntity().toDocumentSnapshot());
  }

  Future<DocumentReference> addWorkoutInfo(WorkoutInfo info) async {
    return _fitnessTrackingPlanRef().add(info.toEntity().toDocumentSnapshot());
  }

  Future<void> addWorkoutDays(WorkoutDays days) async {
    return _fitnessTrackingPlanWorkoutDaysRef(days.workoutId).set(days.toEntity().toDocumentSnapshot());
  }

  Future<DocumentSnapshot> getWorkoutInfoById(String id) {
    return _fitnessTrackingPlanRef().doc(id).get();
  }

  Future<DocumentSnapshot> getWorkoutDaysById(String id) {
    return _fitnessTrackingPlanWorkoutDaysRef(id).get();
  }

  ///It returns twoo document snapshots where the first one is going to be the [WorkoutInfo]
  /// and the second one is [WorkoutDays]
  Future<List<DocumentSnapshot>> getWorkoutById(String workoutId) {
    return Future.wait<DocumentSnapshot>([
      _fitnessTrackingPlanRef().doc(workoutId).get(),
      _fitnessTrackingPlanWorkoutDaysRef(workoutId).get(),
    ]);
  }

  Future<QuerySnapshot> getWorkoutInfosByCreated({
    required int limit,
    DocumentSnapshot? startAfterDocument,
  }) {
    Query query = _fitnessTrackingPlanRef()
        .where(
          WorkoutInfoDocKeys.isPublic,
          isEqualTo: true,
        )
        .orderBy(WorkoutInfoDocKeys.created)
        .limit(limit);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  Future<QuerySnapshot> getWorkoutInfosByUserId(
    String userId, {
    required bool isAuthUserData,
    required int limit,
    DocumentSnapshot? startAfterDocument,
  }) {
    Query query = _fitnessTrackingPlanRef()
        .limit(limit)
        .where(
          WorkoutInfoDocKeys.uid,
          isEqualTo: userId,
        )
        .orderBy(WorkoutInfoDocKeys.created);

    if (!isAuthUserData) {
      query = query.where(WorkoutInfoDocKeys.isPublic, isEqualTo: true);
    }

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  Future<QuerySnapshot> getWorkoutInfosByTitle(
    String value, {
    required int limit,
    DocumentSnapshot? startAfterDocument,
  }) {
    Query query = _fitnessTrackingPlanRef()
        .where(WorkoutInfoDocKeys.isPublic, isEqualTo: true)
        .where(
          WorkoutInfoDocKeys.title,
          isEqualTo: value,
          isGreaterThanOrEqualTo: value,
          isLessThanOrEqualTo: value + '\uf8ff',
        )
        .orderBy(WorkoutInfoDocKeys.created)
        .limit(limit);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  Future<QuerySnapshot> getWorkoutInfosByType(WorkoutType type, {required int limit, DocumentSnapshot? startAfterDocument}) {
    Query query = _fitnessTrackingPlanRef()
        .where(WorkoutInfoDocKeys.isPublic, isEqualTo: true)
        .where(WorkoutInfoDocKeys.type, isEqualTo: true)
        .orderBy(WorkoutInfoDocKeys.created)
        .limit(limit);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  Future<QuerySnapshot> getWorkoutInfosByGoal(WorkoutGoal goal, {required int limit, DocumentSnapshot? startAfterDocument}) {
    Query query = _fitnessTrackingPlanRef()
        .where(WorkoutInfoDocKeys.isPublic, isEqualTo: true)
        .where(WorkoutInfoDocKeys.goal, isEqualTo: describeEnum(goal))
        .orderBy(WorkoutInfoDocKeys.created)
        .limit(limit);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  ///The duration parameter should be in weeks
  Future<QuerySnapshot> getWorkoutInfosByDuration(int duration, {required int limit, DocumentSnapshot? startAfterDocument}) {
    Query query = _fitnessTrackingPlanRef()
        .where(WorkoutInfoDocKeys.isPublic, isEqualTo: true)
        .where(WorkoutInfoDocKeys.duration, isEqualTo: duration)
        .orderBy(WorkoutInfoDocKeys.created)
        .limit(limit);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  /// the first parameter (daysPerWeek) should be the value between including 1-7
  Future<QuerySnapshot> getWorkoutInfosByDaysPerWeek(int daysPerWeek, {required int limit, DocumentSnapshot? startAfterDocument}) {
    Query query = _fitnessTrackingPlanRef()
        .where(WorkoutInfoDocKeys.isPublic, isEqualTo: true)
        .where(WorkoutInfoDocKeys.daysPerWeek, isEqualTo: daysPerWeek)
        .orderBy(WorkoutInfoDocKeys.created)
        .limit(limit);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  // WORKOUT DAY LOGS
  ///////////////////////////////////////////////////////
  Future<DocumentReference> addWorkoutDayLog(WorkoutDayLog log) async {
    return _fitnessTrackingWorkoutLogsRef().add(log.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteWorkoutDayLog(WorkoutDayLog log) async {
    return _fitnessTrackingWorkoutLogsRef().doc(log.id).delete();
  }

  Future<void> updateWorkoutDayLog(WorkoutDayLog log) async {
    return _fitnessTrackingWorkoutLogsRef().doc(log.id).update(log.toEntity().toDocumentSnapshot());
  }

  Future<QuerySnapshot> getWorkoutDayLogByDate(String userId, DateTime date) async {
    final lowerBound = DateTime(date.year, date.month, date.day);
    final upperBound = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _fitnessTrackingWorkoutLogsRef()
        .where(
          WorkoutDayLogDocKeys.userId,
          isEqualTo: userId,
        )
        .where(
          WorkoutDayLogDocKeys.created,
          isGreaterThanOrEqualTo: Timestamp.fromDate(lowerBound),
          isLessThanOrEqualTo: Timestamp.fromDate(upperBound),
        )
        .get();
  }

  Future<DocumentSnapshot> getWorkoutDayLogById(String id) async {
    return _fitnessTrackingWorkoutLogsRef().doc(id).get();
  }

  Future<QuerySnapshot> getWorkoutDayLogByWorkoutId(String userId, String workoutId) async {
    return _fitnessTrackingWorkoutLogsRef()
        .where(
          WorkoutDayLogDocKeys.userId,
          isEqualTo: userId,
        )
        .where(
          WorkoutDayRawDocKeys.workoutId,
          isEqualTo: workoutId,
        )
        .orderBy(
          WorkoutDayLogDocKeys.created,
          descending: true,
        )
        .get();
  }
}
