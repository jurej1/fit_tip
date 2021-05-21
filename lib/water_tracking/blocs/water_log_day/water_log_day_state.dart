part of 'water_log_day_bloc.dart';

abstract class WaterLogDayState {
  const WaterLogDayState();
}

class WaterLogDayLoading extends WaterLogDayState {}

class WaterLogDayLoadSuccess extends WaterLogDayState {
  final List<WaterLog> waterLogs;
  late final double totalDrinked;

  WaterLogDayLoadSuccess({this.waterLogs = const []}) {
    this.totalDrinked = waterLogs.fold(
      0,
      (previousValue, element) => previousValue + element.cup.amount,
    );
  }
}

class WaterLogDayFailure extends WaterLogDayState {
  final String? errorMsg;

  const WaterLogDayFailure({
    this.errorMsg,
  });
}
