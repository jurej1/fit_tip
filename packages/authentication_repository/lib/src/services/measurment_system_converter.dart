/*
  imperial => lb/miles
  metric => kg/km
  hybrid => lb/km
*/

import 'package:authentication_repository/authentication_repository.dart';

class MeasurmentSystemConverter {
  static const _onePoundInKilos = 0.453592;
  static const _oneKiloInPounds = 2.20462;
  static const _oneMileInKm = 1.60934;

  static double lbTokg(double value) => value * _onePoundInKilos;
  static double kgToLb(double value) => value * _oneKiloInPounds;

  static double milesToKm(double value) => value * _oneMileInKm;

  static String measurmentSystemToWeightUnit(MeasurmentSystem system) {
    if (system == MeasurmentSystem.imperial) {
      return 'lb';
    } else {
      return 'kg';
    }
  }
}
