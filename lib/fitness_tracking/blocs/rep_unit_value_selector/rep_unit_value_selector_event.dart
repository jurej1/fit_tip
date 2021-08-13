part of 'rep_unit_value_selector_bloc.dart';

abstract class RepUnitValueSelectorEvent extends Equatable {
  const RepUnitValueSelectorEvent();

  @override
  List<Object> get props => [];
}

class RepUnitValueSelectorListScrollUpdated extends RepUnitValueSelectorEvent {
  final ScrollController scrollController;

  const RepUnitValueSelectorListScrollUpdated(this.scrollController);

  @override
  List<Object> get props => [scrollController];
}

class RepUnitValueSelectorListScrollEnd extends RepUnitValueSelectorEvent {
  final ScrollController scrollController;

  const RepUnitValueSelectorListScrollEnd(this.scrollController);

  @override
  List<Object> get props => [scrollController];
}

class RepUnitValueSelectorListSnapped extends RepUnitValueSelectorEvent {}
