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

  String mapIndexToText() {
    int minutes = mapIndexToMinutes();

    double value = minutes / 60;

    int hours = value.floor();
    int min = (value - hours).toInt() * 60;

    return '${hours}h ${min}min';
  }
}
