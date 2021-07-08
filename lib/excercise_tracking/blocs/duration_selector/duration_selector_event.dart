part of 'duration_selector_bloc.dart';

abstract class DurationSelectorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DurationSelectorScrollUpdated extends DurationSelectorEvent {
  DurationSelectorScrollUpdated({required this.itemWidth, required this.controller});

  final ScrollController controller;
  final double itemWidth;

  @override
  List<Object?> get props => [itemWidth, controller];
}

class DurationSelectorScrollEnd extends DurationSelectorEvent {
  DurationSelectorScrollEnd({required this.itemWidth, required this.controller});
  final ScrollController controller;
  final double itemWidth;

  @override
  List<Object?> get props => [itemWidth, controller];
}

class DurationSelectorListSnapped extends DurationSelectorEvent {}
