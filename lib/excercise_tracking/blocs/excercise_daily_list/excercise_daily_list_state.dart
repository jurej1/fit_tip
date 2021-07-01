part of 'excercise_daily_list_bloc.dart';

abstract class ExcerciseDailyListState extends Equatable {
  const ExcerciseDailyListState();

  @override
  List<Object> get props => [];
}

class ExcerciseDailyListLoading extends ExcerciseDailyListState {
  const ExcerciseDailyListLoading();
}

class ExcerciseDailyListLoadSuccess extends ExcerciseDailyListState {
  final List<ExcerciseLog> excercises;

  const ExcerciseDailyListLoadSuccess([this.excercises = const []]);

  ExcerciseDailyListLoadSuccess copyWith({
    List<ExcerciseLog>? excercises,
  }) {
    return ExcerciseDailyListLoadSuccess(
      excercises ?? this.excercises,
    );
  }
}

class ExcerciseDailyListFailure extends ExcerciseDailyListState {}
