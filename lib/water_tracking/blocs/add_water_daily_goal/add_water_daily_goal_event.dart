part of 'add_water_daily_goal_bloc.dart';

abstract class AddWaterDailyGoalEvent extends Equatable {
  const AddWaterDailyGoalEvent();

  @override
  List<Object> get props => [];
}

class AddWaterDailyGoalAmountChanged extends AddWaterDailyGoalEvent {
  final String value;

  AddWaterDailyGoalAmountChanged(this.value);

  @override
  List<Object> get props => [value];
}

class AddWaterDailyGoalFormSubmit extends AddWaterDailyGoalEvent {}
