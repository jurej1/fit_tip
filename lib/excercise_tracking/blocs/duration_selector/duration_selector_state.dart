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
    double centerOffset = focusedIndex * itemWidth;
    if (this.offset % itemWidth == 0) {
      return centerOffset;
    }

    if (this.offset > centerOffset) {
      double a = offset % centerOffset;

      if (a < 15) {
        return centerOffset;
      } else if (a >= 15) {
        return centerOffset + itemWidth;
      }
    } else if (this.offset < centerOffset) {
      double a = offset % centerOffset;

      if (centerOffset - 15 > a) {
        return centerOffset;
      } else {
        return centerOffset - 30;
      }
    }

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
    double? offset,
  }) {
    return DurationSelectorState(
      focusedIndex: focusedIndex ?? this.focusedIndex,
      offset: offset ?? this.offset,
    );
  }
}
