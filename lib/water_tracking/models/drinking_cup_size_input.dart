import 'package:formz/formz.dart';
import 'package:water_repository/enums/enums.dart';

enum DrinkingCupSizeValidationError { invalid }

class DrinkingCupSizeInput extends FormzInput<DrinkingCupSize, DrinkingCupSizeValidationError> {
  const DrinkingCupSizeInput.pure([DrinkingCupSize cupSize = DrinkingCupSize.medium]) : super.pure(cupSize);
  const DrinkingCupSizeInput.dirty([DrinkingCupSize cupSize = DrinkingCupSize.medium]) : super.dirty(cupSize);

  @override
  DrinkingCupSizeValidationError? validator(DrinkingCupSize? value) {
    if (value == null) {
      return DrinkingCupSizeValidationError.invalid;
    }

    return null;
  }
}
