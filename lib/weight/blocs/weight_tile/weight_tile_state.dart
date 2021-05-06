part of 'weight_tile_bloc.dart';

abstract class WeightTileState extends Equatable {
  const WeightTileState();

  @override
  List<Object> get props => [];
}

class WeightTileInitial extends WeightTileState {}

class WeightTileShortDeleted extends WeightTileState {
  final Weight weight;

  const WeightTileShortDeleted(this.weight);

  @override
  List<Object> get props => [weight];
}

class WeightTileTotalDeleted extends WeightTileState {
  final Weight weight;

  const WeightTileTotalDeleted(this.weight);

  @override
  List<Object> get props => [weight];
}

class WeightTileDeleteLoading extends WeightTileState {}

class WeightTileDeleteFail extends WeightTileState {}

class WeightTileDeletingCanceled extends WeightTileState {
  final Weight weight;

  const WeightTileDeletingCanceled(this.weight);

  @override
  List<Object> get props => [weight];
}
