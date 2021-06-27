part of 'edit_calorie_daily_goal_bloc.dart';

abstract class EditCalorieDailyGoalEvent extends Equatable {
  const EditCalorieDailyGoalEvent();

  @override
  List<Object?> get props => [];
}

class EditCalorieDailyGoalAmountChanged extends EditCalorieDailyGoalEvent {
  final String? amount;

  EditCalorieDailyGoalAmountChanged({this.amount});

  @override
  List<Object?> get props => [amount];
}

class EditCalorieDailyGoalCarbsChanged extends EditCalorieDailyGoalEvent {
  final String amount;

  EditCalorieDailyGoalCarbsChanged(this.amount);
  @override
  List<Object?> get props => [amount];
}

class EditCalorieDailyGoalProteinChanged extends EditCalorieDailyGoalEvent {
  final String amount;
  EditCalorieDailyGoalProteinChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class EditCalorieDailyGoalFatsChanged extends EditCalorieDailyGoalEvent {
  final String amount;
  EditCalorieDailyGoalFatsChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class EditCalorieDailyGoalBreakfastChanged extends EditCalorieDailyGoalEvent{

  final String value;

 const  EditCalorieDailyGoalBreakfastChanged(this.value);

   @override
  List<Object?> get props => [value];
}

class EditCalorieDailyGoalLunchChanged extends EditCalorieDailyGoalEvent {
    final String value;

 const  EditCalorieDailyGoalLunchChanged(this.value);

   @override
  List<Object?> get props => [value];
}

class EditCalorieDailyGoalDinnerChanged extends EditCalorieDailyGoalEvent {
    final String value;

 const  EditCalorieDailyGoalDinnerChanged(this.value);

   @override
  List<Object?> get props => [value];
}

class EditCalorieDailyGoalSnackChanged extends EditCalorieDailyGoalEvent {
    final String value;

 const  EditCalorieDailyGoalSnackChanged(this.value);

   @override
  List<Object?> get props => [value];
}


class EditCalorieDailyGoalFormSubmit extends EditCalorieDailyGoalEvent {}
