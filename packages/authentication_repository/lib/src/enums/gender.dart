import 'package:flutter/foundation.dart';

enum Gender { male, female, ratherNotSay, unknown }

Gender stringToGender(String val) {
  if (val == describeEnum(Gender.female)) {
    return Gender.female;
  } else if (val == describeEnum(Gender.male)) {
    return Gender.male;
  } else if (val == describeEnum(Gender.ratherNotSay)) {
    return Gender.ratherNotSay;
  } else {
    return Gender.unknown;
  }
}
