part of 'excercise_tile_bloc.dart';

abstract class ExcerciseTileState extends Equatable {
  const ExcerciseTileState(
    this.excerciseLog,
    this.isExpanded,
  );

  final ExcerciseLog excerciseLog;
  final bool isExpanded;

  @override
  List<Object> get props => [excerciseLog, isExpanded];
}

class ExcerciseTileInitial extends ExcerciseTileState {
  const ExcerciseTileInitial(ExcerciseLog excerciseLog, bool isExpanded) : super(excerciseLog, isExpanded);
}

class ExcerciseTileLoading extends ExcerciseTileState {
  const ExcerciseTileLoading(ExcerciseLog excerciseLog, bool isExpanded) : super(excerciseLog, isExpanded);
}

class ExcerciseTileDeleteSuccess extends ExcerciseTileState {
  const ExcerciseTileDeleteSuccess(ExcerciseLog excerciseLog, bool isExpanded) : super(excerciseLog, isExpanded);
}

class ExcerciseTileDeleteFail extends ExcerciseTileState {
  const ExcerciseTileDeleteFail(ExcerciseLog excerciseLog, bool isExpanded, {required this.errorMsg}) : super(excerciseLog, isExpanded);

  final String errorMsg;
  @override
  List<Object> get props => [excerciseLog, isExpanded, errorMsg];
}
