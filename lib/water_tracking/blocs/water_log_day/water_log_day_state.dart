part of 'water_log_day_bloc.dart';

abstract class WaterLogDayState extends Equatable {
  const WaterLogDayState();

  @override
  List<Object?> get props => [];
}

class WaterLogDayLoading extends WaterLogDayState {}

class WaterLogDayLoadSuccess extends WaterLogDayState {
  final List<WaterLog> waterLogs;

  const WaterLogDayLoadSuccess({this.waterLogs = const []});
  @override
  List<Object> get props => [waterLogs];
}

class WaterLogDayFailure extends WaterLogDayState {
  final String? errorMsg;

  const WaterLogDayFailure({
    this.errorMsg,
  });

  @override
  List<Object?> get props => [errorMsg];
}
