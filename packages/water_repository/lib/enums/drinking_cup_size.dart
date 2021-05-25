import 'package:flutter/foundation.dart';

enum DrinkingCupSize { tee, coffee, small, medium, large, extraLarge, wine, pintUK, pintUS }

DrinkingCupSize mapDatabaseStringToDrinkingCupSize(String val) {
  if (describeEnum(DrinkingCupSize.coffee) == val) {
    return DrinkingCupSize.coffee;
  } else if (describeEnum(DrinkingCupSize.extraLarge) == val) {
    return DrinkingCupSize.extraLarge;
  } else if (describeEnum(DrinkingCupSize.large) == val) {
    return DrinkingCupSize.large;
  } else if (describeEnum(DrinkingCupSize.medium) == val) {
    return DrinkingCupSize.medium;
  } else if (describeEnum(DrinkingCupSize.pintUK) == val) {
    return DrinkingCupSize.pintUK;
  } else if (describeEnum(DrinkingCupSize.pintUS) == val) {
    return DrinkingCupSize.pintUS;
  } else if (describeEnum(DrinkingCupSize.small) == val) {
    return DrinkingCupSize.small;
  } else if (describeEnum(DrinkingCupSize.tee) == val) {
    return DrinkingCupSize.tee;
  } else if (describeEnum(DrinkingCupSize.wine) == val) {
    return DrinkingCupSize.wine;
  }

  return DrinkingCupSize.medium;
}
