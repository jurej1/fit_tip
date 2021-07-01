part of 'duration_selector_bloc.dart';

abstract class DurationSelectorEvent extends Equatable {
  const DurationSelectorEvent();

  @override
  List<Object> get props => [];
}

class DurationSelectorValueUpdated extends DurationSelectorEvent {
  final ScrollController controller;
  final double itemWidth;
  final double screenWidth;

  const DurationSelectorValueUpdated({
    required this.controller,
    required this.itemWidth,
    required this.screenWidth,
  });

  DurationSelectorValueUpdated copyWith({
    ScrollController? controller,
    double? itemWidth,
    double? screenWidth,
  }) {
    return DurationSelectorValueUpdated(
      controller: controller ?? this.controller,
      itemWidth: itemWidth ?? this.itemWidth,
      screenWidth: screenWidth ?? this.screenWidth,
    );
  }

  @override
  List<Object> get props => [controller, itemWidth, screenWidth];
}
