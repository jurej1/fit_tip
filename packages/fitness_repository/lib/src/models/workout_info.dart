import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/workout_info_entity.dart';
import 'package:intl/intl.dart';

import '../../fitness_repository.dart';

class WorkoutInfo extends Equatable {
  final String id;
  final String uid;

  final String title;
  final WorkoutGoal? goal;
  final WorkoutType? type;

  ///The duration is in weeks
  final int duration;
  final int daysPerWeek;
  final String? note;

  final bool isPublic;
  final int likes;

  final DateTime created;

  final bool isActive;
  final bool isSaved;
  final bool isLiked;

  WorkoutInfo({
    required this.id,
    required this.uid,
    required this.title,
    this.goal,
    this.type,
    required this.duration,
    required this.daysPerWeek,
    this.note,
    this.isPublic = false,
    this.likes = 0,
    DateTime? created,
    this.isActive = false,
    this.isLiked = false,
    this.isSaved = false,
  }) : this.created = created ?? DateTime.now();

  @override
  List<Object?> get props {
    return [id, uid, title, goal, type, duration, daysPerWeek, note, isPublic, likes, created, isActive, isSaved, isLiked];
  }

  WorkoutInfo copyWith({
    String? id,
    String? uid,
    String? title,
    WorkoutGoal? goal,
    WorkoutType? type,
    int? duration,
    int? daysPerWeek,
    String? note,
    bool? isPublic,
    int? likes,
    DateTime? created,
    bool? isActive,
    bool? isSaved,
    bool? isLiked,
  }) {
    return WorkoutInfo(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      note: note ?? this.note,
      isPublic: isPublic ?? this.isPublic,
      likes: likes ?? this.likes,
      created: created ?? this.created,
      isActive: isActive ?? this.isActive,
      isSaved: isSaved ?? this.isSaved,
      isLiked: isLiked ?? this.isLiked,
    );
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
}
