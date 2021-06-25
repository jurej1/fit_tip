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

class EditCalorieDailyGoalFormSubmit extends EditCalorieDailyGoalEvent {}
