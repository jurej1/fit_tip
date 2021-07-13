part of 'draggable_value_selector_bloc.dart';

enum DraggableValueSelectorListState { initial, scrolling, stop, dirty }

class DraggableValueSelectorState extends Equatable {
  const DraggableValueSelectorState({
    this.focusedValue = 0,
    this.listState = DraggableValueSelectorListState.initial,
    this.offset = 0,
  });

  final int focusedValue;
  final DraggableValueSelectorListState listState;
  final double offset;

  @override
  List<Object> get props => [focusedValue, listState, offset];

  DraggableValueSelectorState copyWith({
    int? focusedValue,
    DraggableValueSelectorListState? listState,
    double? offset,
  }) {
    return DraggableValueSelectorState(
      focusedValue: focusedValue ?? this.focusedValue,
      listState: listState ?? this.listState,
      offset: offset ?? this.offset,
    );
  }
}
