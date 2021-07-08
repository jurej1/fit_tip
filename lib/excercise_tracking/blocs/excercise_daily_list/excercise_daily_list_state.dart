part of 'excercise_daily_list_bloc.dart';

abstract class ExcerciseDailyListState {
  const ExcerciseDailyListState();
}

class ExcerciseDailyListLoading extends ExcerciseDailyListState {
  const ExcerciseDailyListLoading();
}

class ExcerciseDailyListLoadSuccess extends ExcerciseDailyListState {
  final List<ExcerciseLog> excercises;

  const ExcerciseDailyListLoadSuccess([this.excercises = const []]);
}

class ExcerciseDailyListFailure extends ExcerciseDailyListState {}
