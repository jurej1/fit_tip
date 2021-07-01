part of 'add_excercise_log_bloc.dart';

class AddExcerciseLogState extends Equatable {
  const AddExcerciseLogState({this.offset = 0.0});

  final double offset;

  @override
  List<Object> get props => [offset];

  AddExcerciseLogState copyWith({
    double? offset,
  }) {
    return AddExcerciseLogState(
      offset: offset ?? this.offset,
    );
  }
}
