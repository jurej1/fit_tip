part of 'rep_unit_value_selector_bloc.dart';

abstract class RepUnitValueSelectorEvent extends Equatable {
  const RepUnitValueSelectorEvent();

  @override
  List<Object> get props => [];
}

class RepUnitValueSelectorListScrollUpdated extends RepUnitValueSelectorEvent {
  final ScrollController scrollController;
  final double itemHeight;

  const RepUnitValueSelectorListScrollUpdated(this.scrollController, this.itemHeight);

  @override
  List<Object> get props => [itemHeight, scrollController];
}

class RepUnitValueSelectorListScrollEnd extends RepUnitValueSelectorEvent {
  final ScrollController scrollController;
  final double itemHeight;

  const RepUnitValueSelectorListScrollEnd(this.scrollController, this.itemHeight);

  @override
  List<Object> get props => [itemHeight, scrollController];
}

class RepUnitValueSelectorListSnapped extends RepUnitValueSelectorEvent {}
