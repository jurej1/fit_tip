part of 'add_excercise_log_bloc.dart';

class AddExcerciseLogState extends Equatable {
  const AddExcerciseLogState({this.offset = 0.0, this.focusedIndex = 0});

  final double offset;
  final int focusedIndex;

  @override
  List<Object> get props => [offset, focusedIndex];

  AddExcerciseLogState copyWith({
    double? offset,
    int? focusedIndex,
  }) {
    return AddExcerciseLogState(
      offset: offset ?? this.offset,
      focusedIndex: focusedIndex ?? this.focusedIndex,
    );
  }

  double getAnimateToValue(double itemWidth) {
    return (itemWidth * focusedIndex);
  }

  int mapIndexToMinutes() {
    return this.focusedIndex * 5;
  }
}
