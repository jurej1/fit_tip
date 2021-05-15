part of 'weight_statistics_bloc.dart';

abstract class WeightStatisticsState extends Equatable {
  const WeightStatisticsState();

  @override
  List<Object?> get props => [];
}

class WeightStatisticsLoading extends WeightStatisticsState {}

class WeightStatisticsLoadedSuccessfully extends WeightStatisticsState {
  final double? sevenDayChange;
  final double? thirdyDayChange;
  final double? totalChange;

  const WeightStatisticsLoadedSuccessfully({
    this.sevenDayChange,
    this.thirdyDayChange,
    this.totalChange,
  });

  WeightStatisticsLoadedSuccessfully copyWith({
    double? sevenDayChange,
    double? thirdyDayChange,
    double? totalChange,
    double? renaming,
    double? percantageDone,
  }) {
    return WeightStatisticsLoadedSuccessfully(
      sevenDayChange: sevenDayChange ?? this.sevenDayChange,
      thirdyDayChange: thirdyDayChange ?? this.thirdyDayChange,
      totalChange: totalChange ?? this.totalChange,
    );
  }

  @override
  List<Object?> get props => [sevenDayChange, thirdyDayChange, totalChange];
}

class WeightStatisticsFail extends WeightStatisticsState {}
