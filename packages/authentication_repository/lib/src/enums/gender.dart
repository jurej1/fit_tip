import 'package:flutter/foundation.dart';

enum Gender { male, female, ratherNotSay, unknown }

Gender stringToGender(String? val) {
  if (val == null) return Gender.unknown;

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

extension GenderX on Gender {
  bool get isMale => this == Gender.male;
  bool get isFemale => this == Gender.female;
  bool get isUnknown => this == Gender.unknown;
  bool get isRatherNotSay => this == Gender.ratherNotSay;

  String toStringReadable() {
    if (this == Gender.male) {
      return 'Male';
    }
    if (this == Gender.female) {
      return 'Female';
    }
    if (this == Gender.unknown) {
      return 'Unknown';
    }
    if (this == Gender.ratherNotSay) {
      return 'Rather not say';
    }

    return '';
  }
}
