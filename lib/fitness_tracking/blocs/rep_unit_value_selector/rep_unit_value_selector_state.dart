part of 'rep_unit_value_selector_bloc.dart';

enum RepUnitValueSelectorListState { initial, scrolling, stop, dirty }

class RepUnitValueSelectorState extends Equatable {
  const RepUnitValueSelectorState({
    this.focusedValue = RepUnit.x,
    this.listState = RepUnitValueSelectorListState.initial,
  });

  final RepUnit focusedValue;
  final RepUnitValueSelectorListState listState;

  @override
  List<Object> get props => [focusedValue, listState];

  RepUnitValueSelectorState copyWith({
    RepUnit? focusedValue,
    RepUnitValueSelectorListState? listState,
  }) {
    return RepUnitValueSelectorState(
      focusedValue: focusedValue ?? this.focusedValue,
      listState: listState ?? this.listState,
    );
  }
}
