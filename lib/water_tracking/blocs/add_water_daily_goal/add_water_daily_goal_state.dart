part of 'add_water_daily_goal_bloc.dart';

class AddWaterDailyGoalState extends Equatable {
  const AddWaterDailyGoalState({
    this.status = FormzStatus.pure,
    this.errorMsg,
    this.amount = const WaterGoalAmount.pure(),
  });

  final FormzStatus status;
  final String? errorMsg;
  final WaterGoalAmount amount;

  @override
  List<Object?> get props => [status, errorMsg, amount];

  AddWaterDailyGoalState copyWith({
    FormzStatus? status,
    String? errorMsg,
    WaterGoalAmount? amount,
  }) {
    return AddWaterDailyGoalState(
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      amount: amount ?? this.amount,
    );
  }
}
