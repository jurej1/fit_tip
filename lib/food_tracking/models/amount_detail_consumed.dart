import 'package:formz/formz.dart';

enum AmountDetailConsumedValidationError { invalid }

class AmountDetailConsumed extends FormzInput<String, AmountDetailConsumedValidationError> {
  const AmountDetailConsumed.dirty([String value = '']) : super.dirty(value);
  const AmountDetailConsumed.pure([String value = '']) : super.pure(value);

  @override
  AmountDetailConsumedValidationError? validator(String? value) {
    if (value == null) {
      return null;
    } else {
      if (value.isEmpty) return null;

      double? parse = double.tryParse(value);

      if (parse == null) {
        return AmountDetailConsumedValidationError.invalid;
      }
      return null;
    }
  }
}
