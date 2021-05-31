part of 'water_grid_tile_bloc.dart';

abstract class WaterGridTileEvent extends Equatable {
  const WaterGridTileEvent();

  @override
  List<Object?> get props => [];
}

class WaterGridTileDeleteRequested extends WaterGridTileEvent {}

class WaterGridTileBlocSliderUpdated extends WaterGridTileEvent {
  final double val;

  const WaterGridTileBlocSliderUpdated(this.val);
}

class WaterGridTileDialogClosed extends WaterGridTileEvent {}

class WaterGridTileTimeUpdated extends WaterGridTileEvent {
  final TimeOfDay? time;

  const WaterGridTileTimeUpdated(this.time);

  @override
  List<Object?> get props => [time];
}
