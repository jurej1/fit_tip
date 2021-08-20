import 'package:authentication_repository/authentication_repository.dart';
import 'package:formz/formz.dart';

enum MeasurmentSystemInputValidatioError { invalid }

class MeasurmentSystemInput extends FormzInput<MeasurmentSystem, MeasurmentSystemInputValidatioError> {
  const MeasurmentSystemInput.dirty([MeasurmentSystem value = MeasurmentSystem.metric]) : super.dirty(value);
  const MeasurmentSystemInput.pure([MeasurmentSystem value = MeasurmentSystem.metric]) : super.pure(value);

  @override
  MeasurmentSystemInputValidatioError? validator(MeasurmentSystem? value) {
    if (value == null) {
      return MeasurmentSystemInputValidatioError.invalid;
    }
    return null;
  }
}
