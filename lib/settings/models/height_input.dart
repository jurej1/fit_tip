import 'package:formz/formz.dart';

enum HeightInputValidationError { invalid }

class HeightInput extends FormzInput<String, HeightInputValidationError> {
  const HeightInput.dirty([String value = '']) : super.dirty(value);
  const HeightInput.pure([String value = '']) : super.pure(value);

  double getDoubleValue() {
    final val = double.tryParse(this.value);

    if (val == null)
      return 0;
    else
      return val;
  }

  @override
  HeightInputValidationError? validator(String? value) {
    if (value == null) {
      return HeightInputValidationError.invalid;
    }
    return null;
  }
}
