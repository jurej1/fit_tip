import 'package:formz/formz.dart';

enum DisplayNameInputValidationError { invalid }

class DisplayNameInput extends FormzInput<String?, DisplayNameInputValidationError> {
  const DisplayNameInput.dirty([String? value]) : super.dirty(value);
  const DisplayNameInput.pure([String? value]) : super.pure(value);

  bool get canEdit => this.value != null;

  @override
  DisplayNameInputValidationError? validator(String? value) {
    return null;
  }
}
