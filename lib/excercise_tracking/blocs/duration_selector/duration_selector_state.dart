part of 'duration_selector_bloc.dart';

class DurationSelectorState extends Equatable {
  const DurationSelectorState({
    this.focusedIndex = 0,
    this.offset = 0,
    this.isScrolling = false,
  });

  final int focusedIndex;
  final double offset;
  final bool isScrolling;

  @override
  List<Object> get props => [focusedIndex, offset, isScrolling];

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

  double horizontalPadding(int index, double itemWidth) {
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

  Duration get animationDuration {
    if (isScrolling) {
      return Duration(milliseconds: 150);
    } else {
      return Duration(milliseconds: 300);
    }
  }

  double verticalPadding(int index, double itemWidth) {
    if (index == focusedIndex) {
      return 0.0;
    } else if (index + 1 == focusedIndex || index - 1 == focusedIndex) {
      return itemWidth * 0.1;
    } else if (index + 2 == focusedIndex || index - 2 == focusedIndex) {
      return itemWidth * 0.15;
    } else if (index + 3 == focusedIndex || index - 3 == focusedIndex) {
      return itemWidth * 0.2;
    } else if (index + 4 == focusedIndex || index - 4 == focusedIndex) {
      return itemWidth * 0.25;
    }

    return itemWidth * 0.3;
  }

  DurationSelectorState copyWith({
    int? focusedIndex,
    double? offset,
    bool? isScrolling,
  }) {
    return DurationSelectorState(
      focusedIndex: focusedIndex ?? this.focusedIndex,
      offset: offset ?? this.offset,
      isScrolling: isScrolling ?? this.isScrolling,
    );
  }
}
