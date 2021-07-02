part of 'duration_selector_bloc.dart';

class DurationSelectorState extends Equatable {
  const DurationSelectorState({this.focusedIndex = 0});

  final int focusedIndex;

  @override
  List<Object> get props => [focusedIndex];

  double getAnimateToValue(double itemWidth) {
    return (itemWidth * focusedIndex);
  }

  int mapIndexToMinutes() {
    return this.focusedIndex * 5;
  }

  static int mapMinutesToIndex(int minutes) {
    return (minutes ~/ 5).toInt();
  }

  String mapIndexToText() {
    int minutes = mapIndexToMinutes();

    double value = minutes / 60;

    int hours = value.floor();
    int min = (value - hours).toInt() * 60;

    return '${hours}h ${min}min';
  }

  DurationSelectorState copyWith({
    int? focusedIndex,
  }) {
    return DurationSelectorState(
      focusedIndex: focusedIndex ?? this.focusedIndex,
    );
  }
}
