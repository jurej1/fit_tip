part of 'water_sheet_tile_bloc.dart';

class WaterSheetTileState extends Equatable {
  const WaterSheetTileState({
    required this.cup,
    this.status = FormzStatus.pure,
    this.errorMsg,
    this.waterLog,
  });

  final WaterCup cup;
  final WaterLog? waterLog;
  final FormzStatus status;
  final String? errorMsg;

  @override
  List<Object?> get props => [cup, waterLog, status, errorMsg];

  WaterSheetTileState copyWith({
    WaterCup? cup,
    WaterLog? waterLog,
    FormzStatus? status,
    String? errorMsg,
  }) {
    return WaterSheetTileState(
      cup: cup ?? this.cup,
      waterLog: waterLog ?? this.waterLog,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
