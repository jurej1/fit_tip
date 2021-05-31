part of 'water_sheet_tile_bloc.dart';

abstract class WaterSheetTileEvent extends Equatable {
  const WaterSheetTileEvent();

  @override
  List<Object> get props => [];
}

class WaterSheetTileAddWater extends WaterSheetTileEvent {}
