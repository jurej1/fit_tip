part of 'weight_tile_bloc.dart';

abstract class WeightTileEvent extends Equatable {
  const WeightTileEvent();

  @override
  List<Object> get props => [];
}

class WeightTileDeleteRequested extends WeightTileEvent {}
