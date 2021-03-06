part of 'draggable_value_selector_bloc.dart';

enum DraggableValueSelectorListState { initial, scrolling, stop, dirty }

class DraggableValueSelectorState extends Equatable {
  const DraggableValueSelectorState({
    required this.focusedValue,
    this.listState = DraggableValueSelectorListState.initial,
    required this.offset,
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

  double getAnimateToValue(double itemHeight) {
    return itemHeight * focusedValue;
  }

  int get amountOfVisibibleItems => 3;

  double getTextSize(int index, double itemHeight) {
    if (index == this.focusedValue) return itemHeight;

    return itemHeight * 0.8;
  }

  Color getTextColor(int index) {
    if (index == focusedValue) {
      return Colors.black;
    }

    return Colors.black45;
  }
}
