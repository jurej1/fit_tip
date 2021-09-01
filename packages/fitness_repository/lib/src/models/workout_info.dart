import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../fitness_repository.dart';

class WorkoutInfo extends Equatable {
  final String id;
  final String uid;

  final String title;
  final WorkoutGoal? goal;
  final WorkoutType? type;
  final int? duration;
  final int daysPerWeek;
  final String? note;

  final bool isPublic;
  final int likes;

  final DateTime created;

  WorkoutInfo({
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
}
