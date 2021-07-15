part of 'rep_unit_value_selector_bloc.dart';

enum RepUnitValueSelectorListState { initial, scrolling, stop, dirty }

class RepUnitValueSelectorState extends Equatable {
  const RepUnitValueSelectorState({
    this.focusedValue = 0,
    this.listState = RepUnitValueSelectorListState.initial,
  });

  final int focusedValue;
  final RepUnitValueSelectorListState listState;

  @override
  List<Object> get props => [focusedValue, listState];

  RepUnitValueSelectorState copyWith({
    int? focusedValue,
    RepUnitValueSelectorListState? listState,
  }) {
    return RepUnitValueSelectorState(
      focusedValue: focusedValue ?? this.focusedValue,
      listState: listState ?? this.listState,
    );
  }

  double getAnimateToValue(double itemHeight) {
    return focusedValue * itemHeight;
  }

  RepUnit get repUnit => RepUnit.values.elementAt(focusedValue);

  double getFontSize(int index, double itemHeight) {
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
}
