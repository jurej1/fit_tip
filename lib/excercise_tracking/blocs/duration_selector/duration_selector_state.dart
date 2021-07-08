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
  double getAnimateToValue(double itemWidth) {
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

  double getPadding(int index, double itemWidth) {
    if (index == focusedIndex) {
      return itemWidth * 0.27;
    } else {
      return itemWidth * 0.35;
    }
  }

  int mapIndexToMinutes() {
    return focusedIndex;
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

  int get itemsLenght {
    return 3600;
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
