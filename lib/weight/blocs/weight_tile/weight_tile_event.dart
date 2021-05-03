part of 'weight_tile_bloc.dart';

abstract class WeightTileEvent extends Equatable {
  const WeightTileEvent();

  @override
  List<Object> get props => [];
}

class WeightTileDelete extends WeightTileEvent {
  final Weight weight;

  const WeightTileDelete(this.weight);

  @override
  List<Object> get props => [weight];
}
