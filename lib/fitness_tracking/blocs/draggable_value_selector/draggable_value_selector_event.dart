part of 'draggable_value_selector_bloc.dart';

abstract class DraggableValueSelectorEvent extends Equatable {
  const DraggableValueSelectorEvent();

  @override
  List<Object> get props => [];
}

class DraggableValueSelectorScrollUpdate extends DraggableValueSelectorEvent {
  final ScrollController scrollController;
  final double itemHeight;

  const DraggableValueSelectorScrollUpdate(this.scrollController, this.itemHeight);

  @override
  List<Object> get props => [itemHeight, scrollController];
}

class DraggableValueSelectorScrollEnd extends DraggableValueSelectorEvent {
  final ScrollController scrollController;
  final double itemHeight;

  const DraggableValueSelectorScrollEnd(this.scrollController, this.itemHeight);

  @override
  List<Object> get props => [itemHeight, scrollController];
}

class DraggableValueSelectorListSnapped extends DraggableValueSelectorEvent {}
