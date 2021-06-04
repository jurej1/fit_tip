part of 'food_log_focused_date_bloc.dart';

abstract class FoodLogFocusedDateEvent extends Equatable {
  const FoodLogFocusedDateEvent();

  @override
  List<Object> get props => [];
}

class FoodLogFocusedDateNextDayPressed extends FoodLogFocusedDateEvent {}

class FoodLogFocusedDatePreviousDayPressed extends FoodLogFocusedDateEvent {}