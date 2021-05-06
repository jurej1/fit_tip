part of 'weight_tile_bloc.dart';

abstract class WeightTileState extends Equatable {
  const WeightTileState();

  @override
  List<Object> get props => [];
}

class WeightTileInitial extends WeightTileState {}

class WeightTileDeleteShortDeleted extends WeightTileState {
  final Weight weight;

  const WeightTileDeleteShortDeleted(this.weight);

  @override
  List<Object> get props => [weight];
}

class WeightTileDeleteTotal extends WeightTileState {
  final Weight weight;

  const WeightTileDeleteTotal(this.weight);

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
