part of 'add_excercise_log_bloc.dart';

class AddExcerciseLogState extends Equatable {
  const AddExcerciseLogState({
    this.focusedIndex = 0,
  });

  final int focusedIndex;

  @override
  List<Object> get props => [focusedIndex];

  AddExcerciseLogState copyWith({
    int? focusedIndex,
  }) {
    return AddExcerciseLogState(
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
