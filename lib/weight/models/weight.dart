import 'package:formz/formz.dart';

enum WeightValidationError { invalid }

class Weight extends FormzInput<String, WeightValidationError> {
  const Weight.dirty([String val = '']) : super.dirty(val);
  const Weight.pure([String val = '']) : super.pure(val);

  @override
  WeightValidationError? validator(String? value) {
    if (value == null) {
      return WeightValidationError.invalid;
    }

    double? valKg = double.tryParse(value);

    if (valKg == null) {
      return WeightValidationError.invalid;
    } else if (valKg.isNegative) {
      return WeightValidationError.invalid;
    }

    return null;
  }
}
