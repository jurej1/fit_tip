part of 'duration_selector_bloc.dart';

enum DurationSelectorStatus { initial, scrolling, scrollEnded, snapped }

class DurationSelectorState extends Equatable {
  const DurationSelectorState({
    required this.focusedIndex,
    this.offset = 0,
    this.status = DurationSelectorStatus.initial,
    required this.itemsLength,
  });

  final int focusedIndex;
  final double offset;
  final DurationSelectorStatus status;
  final int itemsLength;

  @override
  List<Object> get props {
    return [
      focusedIndex,
      offset,
      status,
      itemsLength,
    ];
  }

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

  String mapIndexToText() {
    if (this.focusedIndex < 60) {
      return '${focusedIndex}min';
    } else if (this.focusedIndex % 60 == 0) {
      final double hours = focusedIndex / 60;

      return '${hours.toInt()}h';
    }

    double a = focusedIndex / 60;

    int hours = a.floor();

    int minutes = ((a - hours) * 60).round();

    return '${hours}h ${minutes}min';
  }

  Duration get animationDuration {
    if (status == DurationSelectorStatus.scrolling) {
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
    } else if (index + 5 == focusedIndex || index - 5 == focusedIndex) {
      return itemWidth * 0.3;
    } else if (index + 6 == focusedIndex || index - 6 == focusedIndex) {
      return itemWidth * 0.35;
    }

    return itemWidth * 0.4;
  }

  DurationSelectorState copyWith({
    int? focusedIndex,
    double? offset,
    DurationSelectorStatus? status,
    int? itemsLength,
  }) {
    return DurationSelectorState(
      focusedIndex: focusedIndex ?? this.focusedIndex,
      offset: offset ?? this.offset,
      status: status ?? this.status,
      itemsLength: itemsLength ?? this.itemsLength,
    );
  }
}
