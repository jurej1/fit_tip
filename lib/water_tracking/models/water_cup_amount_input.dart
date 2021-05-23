import 'package:formz/formz.dart';
import 'package:water_repository/water_repository.dart';

enum WaterCupAmountValidationError { invalid }

class WaterCupAmountInput extends FormzInput<double, WaterCupAmountValidationError> {
  WaterCupAmountInput.pure([double value = 00, WaterCup? waterCup]) : super.pure(waterCup != null ? waterCup.amount : value);
  WaterCupAmountInput.dirty([double value = 00, WaterCup? waterCup]) : super.dirty(waterCup != null ? waterCup.amount : value);

  @override
  WaterCupAmountValidationError? validator(double? value) {
    if (value == null) {
      return WaterCupAmountValidationError.invalid;
    }

    return null;
  }
}
