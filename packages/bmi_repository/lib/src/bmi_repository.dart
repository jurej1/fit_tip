import 'package:bmi_calculator/bmi_repository.dart';

import 'models/bmi_result.dart';

class BMIRepository {
  /// The height should be in cm
  /// The mass should be in kg
  BMIResult calcualteBMIkg({required double mass, required double height}) {
    final value = mass / height;

    return BMIResult(category: _bmiResultToCategory(value), value: value);
  }

  /// The mass should be in lbs
  /// THe height should be in inches
  BMIResult calcualteBMIlbs({required double mass, required double height}) {
    final value = (mass / height) * 703;

    return BMIResult(category: _bmiResultToCategory(value), value: value);
  }

  WeightCategory _bmiResultToCategory(double value) {
    if (value < 18.5) {
      return WeightCategory.underweight;
    } else if (value >= 18.5 && value < 25) {
      return WeightCategory.normal;
    } else {
      return WeightCategory.overweight;
    }
  }
}
