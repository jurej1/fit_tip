part of 'excercise_tile_bloc.dart';

abstract class ExcerciseTileEvent extends Equatable {
  const ExcerciseTileEvent();

  @override
  List<Object> get props => [];
}

class ExcerciseTileDeleteRequested extends ExcerciseTileEvent {}

class ExcerciseTilePressed extends ExcerciseTileEvent {}
