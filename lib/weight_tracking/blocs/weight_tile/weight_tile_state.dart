part of 'weight_tile_bloc.dart';

abstract class WeightTileState extends Equatable {
  const WeightTileState();

  @override
  List<Object> get props => [];
}

class WeightTileInitial extends WeightTileState {}

class WeightTileDeletedSuccessfully extends WeightTileState {
  final Weight weight;

  const WeightTileDeletedSuccessfully(this.weight);

  @override
  List<Object> get props => [weight];
}

class WeightTileDeleteLoading extends WeightTileState {}

class WeightTileDeleteFail extends WeightTileState {}
