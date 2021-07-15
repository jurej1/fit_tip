part of 'rep_unit_value_selector_bloc.dart';

enum RepUnitValueSelectorListState { initial, scrolling, stop, dirty }

class RepUnitValueSelectorState extends Equatable {
  const RepUnitValueSelectorState({
    this.focusedValue = 0,
    this.listState = RepUnitValueSelectorListState.initial,
    required this.itemHeight,
  });

  final int focusedValue;
  final double itemHeight;
  final RepUnitValueSelectorListState listState;

  @override
  List<Object> get props => [focusedValue, itemHeight, listState];

  RepUnitValueSelectorState copyWith({
    int? focusedValue,
    double? itemHeight,
    RepUnitValueSelectorListState? listState,
  }) {
    return RepUnitValueSelectorState(
      focusedValue: focusedValue ?? this.focusedValue,
      itemHeight: itemHeight ?? this.itemHeight,
      listState: listState ?? this.listState,
    );
  }

  double getAnimateToValue() {
    return focusedValue * itemHeight;
  }

  RepUnit get repUnit => RepUnit.values.elementAt(focusedValue);

  double getFontSize(int index) {
    if (index == focusedValue) {
      return itemHeight;
    }

    return itemHeight * 0.8;
  }

  Color getFontColor(int index) {
    if (index == focusedValue) {
      return Colors.black;
    }

    return Colors.black45;
  }

  double listSize() {
    return itemHeight * 2;
  }

  double width() {
    return listSize() * 1.5;
  }

  double getVerticalPadding() {
    return (listSize() * 0.5) - itemHeight / 2;
  }
}
