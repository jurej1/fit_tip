import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum ExcerciseIntensityValidationError { invalid }

class ExcerciseIntensity extends FormzInput<Intensity, ExcerciseIntensityValidationError> {
  const ExcerciseIntensity.dirty([Intensity value = Intensity.moderate]) : super.dirty(value);
  const ExcerciseIntensity.pure([Intensity value = Intensity.moderate]) : super.pure(value);

  @override
  ExcerciseIntensityValidationError? validator(Intensity? value) {
    if (value == null) {
      return ExcerciseIntensityValidationError.invalid;
    }

    return null;
  }
}
