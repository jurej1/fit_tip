import 'package:formz/formz.dart';

enum AmountConsumedValidationError { invalid }

class AmountConsumed extends FormzInput<String, AmountConsumedValidationError> {
  const AmountConsumed.dirty([String value = '']) : super.dirty(value);
  const AmountConsumed.pure([String value = '']) : super.pure(value);

  @override
  AmountConsumedValidationError? validator(String? value) {
    if (value == null) {
      return AmountConsumedValidationError.invalid;
    }

    final double? val = double.tryParse(value);
    if (val == null) {
      return AmountConsumedValidationError.invalid;
    }

    return null;
  }
}
