part of 'duration_selector_bloc.dart';

class DurationSelectorState extends Equatable {
  const DurationSelectorState({
    this.focusedIndex = 0,
    this.offset = 0,
  });

  final int focusedIndex;
  final double offset;

  @override
  List<Object> get props => [focusedIndex, offset];
  double getAnimateToValue(
    double itemWidth,
  ) {
    return itemWidth * focusedIndex;
  }

  Color backgroundColor(int index) {
    if (focusedIndex == index) {
      return Colors.blue;
    } else if (focusedIndex < index) {
      return Colors.grey.shade300;
    } else {
      return Colors.blue.shade100;
    }
  }

  int mapIndexToMinutes() {
    return this.focusedIndex;
  }

  static int mapMinutesToIndex(int minutes) {
    return minutes.toInt();
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
    double? offset,
  }) {
    return DurationSelectorState(
      focusedIndex: focusedIndex ?? this.focusedIndex,
      offset: offset ?? this.offset,
    );
  }
}
