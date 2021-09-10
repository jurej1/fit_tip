import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/workout_info_entity.dart';
import 'package:intl/intl.dart';
import 'package:fitness_repository/fitness_repository.dart';

import '../../fitness_repository.dart';

abstract class WorkoutInfoRaw extends Equatable {
  final String id;
  final String uid;

  final String title;
  final WorkoutGoal? goal;
  final WorkoutType? type;

  ///The duration is in weeks
  final int duration;
  final int daysPerWeek;
  final String? note;

  final DateTime created;

  WorkoutInfoRaw({
    required this.id,
    required this.uid,
    required this.title,
    this.goal,
    this.type,
    required this.duration,
    required this.daysPerWeek,
    this.note,
    DateTime? created,
  }) : this.created = created ?? DateTime.now();

  @override
  List<Object?> get props {
    return [
      id,
      uid,
      title,
      goal,
      type,
      duration,
      daysPerWeek,
      note,
      created,
    ];
  }

  String get mapDaysPerWeekToText {
    if (daysPerWeek == 1) {
      return '$daysPerWeek day per week';
    }

    return '$daysPerWeek days per week';
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, ' 'yy').format(date);
  }

  String get mapCreatedToText {
    return _formatDate(created);
  }
}

extension WorkoutInfoXX on WorkoutInfoRaw {
  bool get isActiveWorkoutInfo => this is ActiveWorkoutInfo;
  bool get isWorkoutInfo => this is WorkoutInfo;
}

class WorkoutInfo extends WorkoutInfoRaw {
  final bool isPublic;
  final int likes;

  final bool isActive;
  final bool isSaved;
  final Like like;
  final bool isOwner;

  WorkoutInfo({
    this.isPublic = false,
    this.isActive = false,
    this.like = Like.none,
    this.isSaved = false,
    this.isOwner = false,
    this.likes = 0,
    required String id,
    required String uid,
    required String title,
    WorkoutGoal? goal,
    WorkoutType? type,
    required int duration,
    required int daysPerWeek,
    String? note,
    DateTime? created,
  }) : super(
          daysPerWeek: daysPerWeek,
          duration: duration,
          id: id,
          title: title,
          uid: uid,
          created: created,
          goal: goal,
          note: note,
          type: type,
        );

  @override
  List<Object?> get props => [
        isPublic,
        likes,
        isSaved,
        like,
        isActive,
        daysPerWeek,
        duration,
        id,
        title,
        uid,
        created,
        goal,
        note,
        type,
        isOwner,
      ];

  WorkoutInfo copyWith({
    bool? isPublic,
    int? likes,
    bool? isActive,
    bool? isSaved,
    Like? like,
    int? daysPerWeek,
    int? duration,
    String? id,
    String? title,
    String? uid,
    DateTime? created,
    WorkoutGoal? goal,
    String? note,
    WorkoutType? type,
    bool? isOwner,
  }) {
    return WorkoutInfo(
      isPublic: isPublic ?? this.isPublic,
      likes: likes ?? this.likes,
      isActive: isActive ?? this.isActive,
      isSaved: isSaved ?? this.isSaved,
      like: like ?? this.like,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      duration: duration ?? this.duration,
      id: id ?? this.id,
      title: title ?? this.title,
      uid: uid ?? this.uid,
      created: created ?? this.created,
      goal: goal ?? this.goal,
      note: note ?? this.note,
      type: type ?? this.type,
      isOwner: isOwner ?? this.isOwner,
    );
  }

  static List<WorkoutInfo> fromQuerySnapshot(
    QuerySnapshot snapshot, {
    String? authUserId,
    String? activeWorkoutId,
    List<String> savedWorkoutIds = const [],
    List<String> likedWorkoutids = const [],
  }) {
    return snapshot.docs.map((e) {
      WorkoutInfo info = WorkoutInfo.fromEntiy(WorkoutInfoEntity.fromDocumentSnapshot(e));

      log(info.toString());

      info = info.copyWith(
        isActive: activeWorkoutId == info.id,
        like: likedWorkoutids.contains(info.id) ? Like.up : Like.none,
        isSaved: savedWorkoutIds.contains(info.id),
        isOwner: authUserId == info.id,
      );

      return info;
    }).toList();
  }

  WorkoutInfoEntity toEntity() {
    return WorkoutInfoEntity(
      id: id,
      uid: uid,
      title: title,
      daysPerWeek: daysPerWeek,
      created: this.created,
      duration: this.duration,
      goal: this.goal,
      isPublic: this.isPublic,
      likes: this.likes,
      note: this.note,
      type: this.type,
    );
  }

  static WorkoutInfo fromEntiy(WorkoutInfoEntity entity) {
    return WorkoutInfo(
      id: entity.id,
      uid: entity.uid,
      title: entity.title,
      daysPerWeek: entity.daysPerWeek,
      created: entity.created,
      duration: entity.duration,
      goal: entity.goal,
      isPublic: entity.isPublic,
      likes: entity.likes ?? 0,
      note: entity.note,
      type: entity.type,
    );
  }
}

class ActiveWorkoutInfo extends WorkoutInfoRaw {
  final DateTime startDate;
  final bool isActive;

  ActiveWorkoutInfo({
    required this.startDate,
    required String id,
    required String uid,
    required String title,
    WorkoutGoal? goal,
    WorkoutType? type,
    required int duration,
    required int daysPerWeek,
    String? note,
    DateTime? created,
    this.isActive = false,
  }) : super(
          daysPerWeek: daysPerWeek,
          duration: duration,
          id: id,
          title: title,
          uid: uid,
          created: created,
          goal: goal,
          note: note,
          type: type,
        );

  @override
  List<Object?> get props => [startDate, id, uid, title, goal, type, duration, daysPerWeek, note, created, isActive];

  ActiveWorkoutInfo copyWith({
    DateTime? startDate,
    int? daysPerWeek,
    int? duration,
    String? id,
    String? title,
    String? uid,
    DateTime? created,
    WorkoutGoal? goal,
    String? note,
    WorkoutType? type,
    bool? isActive,
  }) {
    return ActiveWorkoutInfo(
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      duration: duration ?? this.duration,
      id: id ?? this.id,
      title: title ?? this.title,
      uid: uid ?? this.uid,
      created: created ?? this.created,
      goal: goal ?? this.goal,
      note: note ?? this.note,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      isActive: isActive ?? this.isActive,
    );
  }

  ActiveWorkoutInfoEntity toEntity() {
    return ActiveWorkoutInfoEntity(
      created: this.created,
      daysPerWeek: this.daysPerWeek,
      duration: this.duration,
      id: this.id,
      startDate: this.startDate,
      title: this.title,
      uid: this.uid,
      goal: this.goal,
      note: this.note,
      type: this.type,
    );
  }

  static ActiveWorkoutInfo fromEntity(ActiveWorkoutInfoEntity entity) {
    return ActiveWorkoutInfo(
      startDate: entity.startDate,
      id: entity.id,
      uid: entity.uid,
      title: entity.title,
      duration: entity.duration,
      daysPerWeek: entity.daysPerWeek,
      created: entity.created,
      goal: entity.goal,
      note: entity.note,
      type: entity.type,
    );
  }

  factory ActiveWorkoutInfo.fromInfo(WorkoutInfo info, [String? activeWorkoutId]) {
    return ActiveWorkoutInfo(
      startDate: DateTime.now(),
      id: info.id,
      uid: info.uid,
      title: info.title,
      duration: info.duration,
      daysPerWeek: info.daysPerWeek,
      created: info.created,
      goal: info.goal,
      note: info.note,
      type: info.type,
      isActive: false,
    );
  }
}
