import 'package:formz/formz.dart';
import 'package:water_repository/water_repository.dart';

enum WaterCupInputValidationError { invalid }

class WaterCupInput extends FormzInput<WaterCup, WaterCupInputValidationError> {
  const WaterCupInput.pure([WaterCup cup = WaterCups.medium]) : super.pure(cup);
  const WaterCupInput.dirty([WaterCup cup = WaterCups.medium]) : super.dirty(cup);

  @override
  WaterCupInputValidationError? validator(value) {
    if (value == null) {
      return WaterCupInputValidationError.invalid;
    }

    return null;
  }
}
