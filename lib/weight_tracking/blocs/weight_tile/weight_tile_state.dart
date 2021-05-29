part of 'weight_tile_bloc.dart';

abstract class WeightTileState extends Equatable {
  const WeightTileState(this.weight);

  final Weight weight;

  @override
  List<Object> get props => [];
}

class WeightTileInitial extends WeightTileState {
  WeightTileInitial(Weight weight) : super(weight);
}

class WeightTileDeletedSuccessfully extends WeightTileState {
  WeightTileDeletedSuccessfully(Weight weight) : super(weight);
}

class WeightTileDeleteLoading extends WeightTileState {
  WeightTileDeleteLoading(Weight weight) : super(weight);
}

class WeightTileDeleteFail extends WeightTileState {
  WeightTileDeleteFail(Weight weight) : super(weight);
}
