part of 'excercise_daily_list_bloc.dart';

abstract class ExcerciseDailyListEvent extends Equatable {
  const ExcerciseDailyListEvent();

  @override
  List<Object?> get props => [];
}

class ExcerciseDailyListDateUpdated extends ExcerciseDailyListEvent {
  final DateTime date;

  const ExcerciseDailyListDateUpdated(this.date);
  @override
  List<Object> get props => [date];
}

class ExcerciseDailyListLogAdded extends ExcerciseDailyListEvent {
  final ExcerciseLog? log;

  const ExcerciseDailyListLogAdded(this.log);

  @override
  List<Object?> get props => [log];
}

class ExcerciseDailyListLogRemoved extends ExcerciseDailyListEvent {
  final ExcerciseLog? log;
  const ExcerciseDailyListLogRemoved(this.log);

  @override
  List<Object?> get props => [log];
}

class ExcerciseDailyListLogUpdated extends ExcerciseDailyListEvent {
  final ExcerciseLog? log;

  const ExcerciseDailyListLogUpdated(this.log);

  @override
  List<Object?> get props => [log];
}
