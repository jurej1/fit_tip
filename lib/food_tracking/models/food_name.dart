import 'package:formz/formz.dart';

enum FoodNameValidationError { invalid }

class FoodName extends FormzInput<String, FoodNameValidationError> {
  const FoodName.pure([String val = '']) : super.pure(val);
  const FoodName.dirty([String val = '']) : super.dirty(val);

  @override
  FoodNameValidationError? validator(String? value) {
    if (value == null) {
      return FoodNameValidationError.invalid;
    }
    return null;
  }
}
