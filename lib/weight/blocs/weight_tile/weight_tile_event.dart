part of 'weight_tile_bloc.dart';

abstract class WeightTileEvent extends Equatable {
  const WeightTileEvent();

  @override
  List<Object> get props => [];
}

class WeightTileDeleteShort extends WeightTileEvent {}

class WeightTileSnackbarClosed extends WeightTileEvent {
  final SnackBarClosedReason closeReason;

  const WeightTileSnackbarClosed(this.closeReason);

  @override
  List<Object> get props => [closeReason];
}

class WeightTileCancelDeleting extends WeightTileEvent {}
