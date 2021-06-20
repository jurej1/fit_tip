part of 'meal_custom_tile_bloc.dart';

class MealCustomTileState extends Equatable {
  const MealCustomTileState({this.isExpanded = false});

  final bool isExpanded;

  @override
  List<Object> get props => [isExpanded];

  MealCustomTileState copyWith({
    bool? isExpanded,
  }) {
    return MealCustomTileState(
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
