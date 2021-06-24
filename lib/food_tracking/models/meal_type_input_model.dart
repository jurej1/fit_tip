import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

enum MealTypeInputModelValidationError { invalid }

class MealTypeInputFormzModel extends FormzInput<MealType, MealTypeInputModelValidationError> {
  const MealTypeInputFormzModel.dirty([MealType value = MealType.lunch]) : super.dirty(value);
  const MealTypeInputFormzModel.pure([MealType value = MealType.lunch]) : super.pure(value);

  @override
  MealTypeInputModelValidationError? validator(MealType? value) {
    if (value == null) {
      return MealTypeInputModelValidationError.invalid;
    }

    return null;
  }
}
