enum MealType {
  snack,
  dinner,
  breakfast,
  lunch,
}

String mapMealTypeToString(MealType type) {
  if (type == MealType.breakfast) {
    return 'Breakfast';
  } else if (type == MealType.dinner) {
    return 'Dinner';
  } else if (type == MealType.lunch) {
    return 'Lunch';
  } else {
    return 'Snack';
  }
}
