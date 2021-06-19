enum Macronutrient {
  protein,
  carbs,
  fat,
  fiber,
  sugar,
  sodium,
  calcium,
}

String macronutrientToString(Macronutrient a) {
  if (a == Macronutrient.calcium) {
    return 'Calcium';
  } else if (a == Macronutrient.carbs) {
    return 'Carbs';
  } else if (a == Macronutrient.fat) {
    return 'Fat';
  } else if (a == Macronutrient.fiber) {
    return 'Fiber';
  } else if (a == Macronutrient.protein) {
    return 'Protein';
  } else if (a == Macronutrient.sodium) {
    return 'Sodium';
  } else if (a == Macronutrient.sugar) {
    return 'Sugar';
  }

  return '';
}
