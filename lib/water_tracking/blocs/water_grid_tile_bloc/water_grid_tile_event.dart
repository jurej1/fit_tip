part of 'water_grid_tile_bloc.dart';

abstract class WaterGridTileEvent extends Equatable {
  const WaterGridTileEvent();

  @override
  List<Object> get props => [];
}

class WaterGridTileDeleteRequested extends WaterGridTileEvent {}

class WaterGridTileBlocsliderUpdated extends WaterGridTileEvent {
  final double val;

  const WaterGridTileBlocsliderUpdated(this.val);
}
