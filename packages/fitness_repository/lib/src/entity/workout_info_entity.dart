import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../fitness_repository.dart';

class WorkoutInfoDocKeys {
  static String uid = 'uid';
  static String title = 'title';
  static String goal = 'goal';
  static String type = 'type';
  static String duration = 'duration';
  static String daysPerWeek = 'daysPerWeek';
  static String note = 'note';
  static String isPublic = 'isPublic';
  static String likes = 'likes';
  static String created = 'created';
  static String id = 'id';
}

class WorkoutInfoEntity extends Equatable {
  final String id;
  final String uid;

  final String title;
  final WorkoutGoal? goal;
  final WorkoutType? type;
  final int duration;
  final int daysPerWeek;
  final String? note;
  final DateTime created;

  final bool isPublic;
  final int? likes;

  WorkoutInfoEntity({
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
      isPublic,
      likes,
      created,
    ];
  }

  WorkoutInfoEntity copyWith({
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
  }) {
    return WorkoutInfoEntity(
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
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      WorkoutInfoDocKeys.created: Timestamp.fromDate(this.created),
      if (this.likes != null || likes != 0) WorkoutInfoDocKeys.likes: this.likes,
      WorkoutInfoDocKeys.title: this.title,
      WorkoutInfoDocKeys.daysPerWeek: this.daysPerWeek,
      WorkoutInfoDocKeys.duration: this.duration,
      if (this.goal != null) WorkoutInfoDocKeys.goal: describeEnum(goal!),
      if (this.type != null) WorkoutInfoDocKeys.type: describeEnum(type!),
      WorkoutInfoDocKeys.isPublic: this.isPublic,
      if (this.note != null) WorkoutInfoDocKeys.note: this.note,
      WorkoutInfoDocKeys.uid: this.uid,
    };
  }

  static WorkoutInfoEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final timestamp = data[WorkoutInfoDocKeys.created] as Timestamp;

    return WorkoutInfoEntity(
      id: snapshot.id,
      uid: data[WorkoutInfoDocKeys.uid],
      title: data[WorkoutInfoDocKeys.title],
      daysPerWeek: data[WorkoutInfoDocKeys.daysPerWeek],
      created: timestamp.toDate(),
      note: data.containsKey(WorkoutInfoDocKeys.note) ? data[WorkoutInfoDocKeys.note] : null,
      duration: data.containsKey(WorkoutInfoDocKeys.duration) ? data[WorkoutInfoDocKeys.duration] : null,
      goal: data.containsKey(WorkoutInfoDocKeys.goal)
          ? WorkoutGoal.values.firstWhere((e) => data[WorkoutInfoDocKeys.goal] == describeEnum(e))
          : null,
      isPublic: data[WorkoutInfoDocKeys.isPublic],
      likes: data.containsKey(WorkoutInfoDocKeys.likes) ? data[WorkoutInfoDocKeys.likes] : 0,
      type: data.containsKey(WorkoutInfoDocKeys.type)
          ? WorkoutType.values.firstWhere((e) => data[WorkoutInfoDocKeys.type] == describeEnum(e))
          : null,
    );
  }
}

class ActiveWorkoutInfoDocKeys {
  static String uid = 'uid';
  static String title = 'title';
  static String goal = 'goal';
  static String type = 'type';
  static String duration = 'duration';
  static String daysPerWeek = 'daysPerWeek';
  static String note = 'note';
  static String created = 'created';
  static String id = 'id';
  static String startDate = 'startDate';
}

class ActiveWorkoutInfoEntity extends Equatable {
  final String id;
  final String uid;

  final String title;
  final WorkoutGoal? goal;
  final WorkoutType? type;
  final int duration;
  final int daysPerWeek;
  final String? note;
  final DateTime created;
  final DateTime startDate;

  ActiveWorkoutInfoEntity({
    required this.id,
    required this.uid,
    required this.title,
    this.goal,
    this.type,
    required this.duration,
    required this.daysPerWeek,
    this.note,
    required this.created,
    required this.startDate,
  });

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
      startDate,
    ];
  }

  ActiveWorkoutInfoEntity copyWith({
    String? id,
    String? uid,
    String? title,
    WorkoutGoal? goal,
    WorkoutType? type,
    int? duration,
    int? daysPerWeek,
    String? note,
    DateTime? created,
    DateTime? startDate,
  }) {
    return ActiveWorkoutInfoEntity(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      note: note ?? this.note,
      created: created ?? this.created,
      startDate: startDate ?? this.startDate,
    );
  }

  static WorkoutInfoEntity fromActiveMap(Map<String, dynamic> data) {
    final timestamp = data[ActiveWorkoutInfoDocKeys.created] as Timestamp;

    return WorkoutInfoEntity(
      id: data[ActiveWorkoutInfoDocKeys.id],
      uid: data[ActiveWorkoutInfoDocKeys.uid],
      title: data[ActiveWorkoutInfoDocKeys.title],
      daysPerWeek: data[ActiveWorkoutInfoDocKeys.daysPerWeek],
      created: timestamp.toDate(),
      note: data.containsKey(ActiveWorkoutInfoDocKeys.note) ? data[ActiveWorkoutInfoDocKeys.note] : null,
      duration: data.containsKey(ActiveWorkoutInfoDocKeys.duration) ? data[ActiveWorkoutInfoDocKeys.duration] : null,
      goal: data.containsKey(ActiveWorkoutInfoDocKeys.goal)
          ? WorkoutGoal.values.firstWhere((e) => data[ActiveWorkoutInfoDocKeys.goal] == describeEnum(e))
          : null,
      type: data.containsKey(ActiveWorkoutInfoDocKeys.type)
          ? WorkoutType.values.firstWhere((e) => data[ActiveWorkoutInfoDocKeys.type] == describeEnum(e))
          : null,
    );
  }

  Map<String, dynamic> toActiveMap() {
    return {
      ActiveWorkoutInfoDocKeys.id: this.id,
      ActiveWorkoutInfoDocKeys.created: Timestamp.fromDate(this.created),
      ActiveWorkoutInfoDocKeys.title: this.title,
      ActiveWorkoutInfoDocKeys.daysPerWeek: this.daysPerWeek,
      ActiveWorkoutInfoDocKeys.duration: this.duration,
      if (this.goal != null) ActiveWorkoutInfoDocKeys.goal: describeEnum(goal!),
      if (this.type != null) ActiveWorkoutInfoDocKeys.type: describeEnum(type!),
      if (this.note != null) ActiveWorkoutInfoDocKeys.note: this.note,
      ActiveWorkoutInfoDocKeys.uid: this.uid,
      ActiveWorkoutInfoDocKeys.startDate: Timestamp.fromDate(this.startDate)
    };
  }
}
