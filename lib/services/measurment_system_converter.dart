/*
  imperial => lb/miles
  metric => kg/km
  hybrid => lb/km
*/

class MeasurmentSystemConverter {
  static const _onePoundInKilos = 0.453592;
  static const _oneMileInKm = 1.60934;

  static double lbTokg(double value) => value * _onePoundInKilos;
  static double milesToKm(double value) => value * _oneMileInKm;
}
