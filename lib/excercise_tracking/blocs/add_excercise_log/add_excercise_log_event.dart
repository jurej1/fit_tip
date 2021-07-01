part of 'add_excercise_log_bloc.dart';

abstract class AddExcerciseLogEvent extends Equatable {
  const AddExcerciseLogEvent();

  @override
  List<Object> get props => [];
}

class AddExcerciseLogDurationUpdated extends AddExcerciseLogEvent {
  final ScrollController controller;
  final double itemWidth;
  final double screenWidth;

  const AddExcerciseLogDurationUpdated({
    required this.controller,
    required this.itemWidth,
    required this.screenWidth,
  });
  @override
  List<Object> get props => [controller, itemWidth, screenWidth];
}
