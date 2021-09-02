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
}

class WorkoutInfoEntity extends Equatable {
  final String id;
  final String uid;

  final String title;
  final WorkoutGoal? goal;
  final WorkoutType? type;
  final int? duration;
  final int daysPerWeek;
  final String? note;

  final bool isPublic;
  final int? likes;

  final DateTime created;

  WorkoutInfoEntity({
    required this.id,
    required this.uid,
    required this.title,
    this.goal,
    this.type,
    this.duration,
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
      if (this.duration != null) WorkoutInfoDocKeys.duration: this.duration,
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
