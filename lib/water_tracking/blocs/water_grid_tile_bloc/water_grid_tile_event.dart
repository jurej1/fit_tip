part of 'water_grid_tile_bloc.dart';

abstract class WaterGridTileEvent extends Equatable {
  const WaterGridTileEvent();

  @override
  List<Object> get props => [];
}

class WaterGridTileDeleteRequested extends WaterGridTileEvent {}
