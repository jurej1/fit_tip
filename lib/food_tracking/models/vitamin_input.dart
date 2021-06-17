import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

enum VitaminValidationError { invalid }

class VitaminInput extends FormzInput<Vitamin, VitaminValidationError> {
  const VitaminInput.pure([Vitamin value = Vitamin.a]) : super.pure(value);
  const VitaminInput.dirty([Vitamin value = Vitamin.a]) : super.dirty(value);

  @override
  VitaminValidationError? validator(Vitamin? value) {
    if (value == null) {
      return VitaminValidationError.invalid;
    }

    return null;
  }
}
