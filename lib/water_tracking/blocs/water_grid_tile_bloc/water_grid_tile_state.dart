part of 'water_grid_tile_bloc.dart';

abstract class WaterGridTileState extends Equatable {
  const WaterGridTileState(
    this.waterLog,
  );

  final WaterLog waterLog;

  @override
  List<Object> get props => [waterLog];
}

class WaterGridTileInitial extends WaterGridTileState {
  WaterGridTileInitial(WaterLog waterLog) : super(waterLog);
}

class WaterGridTileDirty extends WaterGridTileState {
  WaterGridTileDirty(WaterLog waterLog) : super(waterLog);
}

class WaterGridTileLoading extends WaterGridTileState {
  WaterGridTileLoading(WaterLog waterLog) : super(waterLog);
}

class WaterGridTileDeletingSuccess extends WaterGridTileState {
  WaterGridTileDeletingSuccess(WaterLog waterLog) : super(waterLog);
}

class WaterGridTileFailure extends WaterGridTileState {
  WaterGridTileFailure(WaterLog waterLog) : super(waterLog);
}

class WaterGridTileSuccessfullyUpdated extends WaterGridTileState {
  WaterGridTileSuccessfullyUpdated(WaterLog waterLog) : super(waterLog);
}
