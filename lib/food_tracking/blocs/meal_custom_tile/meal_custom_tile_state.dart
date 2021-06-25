part of 'meal_custom_tile_bloc.dart';

class MealCustomTileState extends Equatable {
  const MealCustomTileState({
    this.isExpanded = false,
    this.textActiveColor = Colors.blue,
  });

  final bool isExpanded;
  final Color textActiveColor;
  @override
  List<Object> get props => [isExpanded, textActiveColor];

  MealCustomTileState copyWith({
    bool? isExpanded,
    Color? textActiveColor,
  }) {
    return MealCustomTileState(
      isExpanded: isExpanded ?? this.isExpanded,
      textActiveColor: textActiveColor ?? this.textActiveColor,
    );
  }
}
