import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/workout_info_entity.dart';
import 'package:intl/intl.dart';

import '../../fitness_repository.dart';

abstract class WorkoutInfoX extends Equatable {
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

  WorkoutInfoX({
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

extension WorkoutInfoXX on WorkoutInfoX {
  bool get isActiveWorkoutInfo => this is ActiveWorkoutInfo;
  bool get isWorkoutInfo => this is WorkoutInfo;
}

class WorkoutInfo extends WorkoutInfoX {
  final bool isPublic;
  final int likes;

  final bool isActive;
  final bool isSaved;
  final bool isLiked;

  WorkoutInfo({
    this.isPublic = false,
    this.isActive = false,
    this.isLiked = false,
    this.isSaved = false,
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
        isLiked,
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
      ];

  WorkoutInfo copyWith({
    bool? isPublic,
    int? likes,
    bool? isActive,
    bool? isSaved,
    bool? isLiked,
    int? daysPerWeek,
    int? duration,
    String? id,
    String? title,
    String? uid,
    DateTime? created,
    WorkoutGoal? goal,
    String? note,
    WorkoutType? type,
  }) {
    return WorkoutInfo(
      isPublic: isPublic ?? this.isPublic,
      likes: likes ?? this.likes,
      isActive: isActive ?? this.isActive,
      isSaved: isSaved ?? this.isSaved,
      isLiked: isLiked ?? this.isLiked,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      duration: duration ?? this.duration,
      id: id ?? this.id,
      title: title ?? this.title,
      uid: uid ?? this.uid,
      created: created ?? this.created,
      goal: goal ?? this.goal,
      note: note ?? this.note,
      type: type ?? this.type,
    );
  }

  static List<WorkoutInfo> fromQuerySnapshot(
    QuerySnapshot snapshot, {
    String? activeWorkoutId,
  }) {
    //TODO, likes and it is saved,
    return snapshot.docs.map((e) {
      WorkoutInfo info = WorkoutInfo.fromEntiy(
        WorkoutInfoEntity.fromDocumentSnapshot(e),
      );

      info = info.copyWith(
        isActive: activeWorkoutId == info.id,
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

class ActiveWorkoutInfo extends WorkoutInfoX {
  final DateTime startDate;
  final String activeWorkoutId;

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
    required this.activeWorkoutId,
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
  List<Object?> get props => [startDate, id, uid, title, goal, type, duration, daysPerWeek, note, created, activeWorkoutId];

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
    String? activeWorkoutId,
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
      activeWorkoutId: activeWorkoutId ?? this.activeWorkoutId,
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
      activeWorkoutId: activeWorkoutId,
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
      activeWorkoutId: entity.activeWorkoutId,
    );
  }

  factory ActiveWorkoutInfo.fromInfo(WorkoutInfo info, [String? activeWorkoutId]) {
    return ActiveWorkoutInfo(
      activeWorkoutId: activeWorkoutId ?? '',
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
    );
  }
}
