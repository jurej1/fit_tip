import 'package:flutter/foundation.dart';

enum Gender { male, female, ratherNotSay }

Gender stringToGender(String val) {
  if (val == describeEnum(Gender.female)) {
    return Gender.female;
  } else if (val == describeEnum(Gender.male)) {
    return Gender.male;
  } else {
    return Gender.ratherNotSay;
  }
}
