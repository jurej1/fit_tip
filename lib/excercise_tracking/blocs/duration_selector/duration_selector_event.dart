part of 'duration_selector_bloc.dart';

abstract class DurationSelectorEvent extends Equatable {
  const DurationSelectorEvent();

  @override
  List<Object> get props => [];
}

class DurationSelectorValueUpdated extends DurationSelectorEvent {
  final ScrollController controller;
  final double itemWidth;

  const DurationSelectorValueUpdated({
    required this.controller,
    required this.itemWidth,
  });

  @override
  List<Object> get props => [controller, itemWidth];
}
