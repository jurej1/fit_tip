part of 'excercise_daily_focused_date_bloc.dart';

abstract class ExcerciseDailyFocusedDateEvent extends Equatable {
  const ExcerciseDailyFocusedDateEvent();

  @override
  List<Object> get props => [];
}

class ExcerciseDailyFocusedDateNextDayPressed extends ExcerciseDailyFocusedDateEvent {}

class ExcerciseDailyFocusedDatePreviousDayPressed extends ExcerciseDailyFocusedDateEvent {}
