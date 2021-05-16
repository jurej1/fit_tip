import 'package:flutter/foundation.dart';

enum WeeklyGoal {
  lose1kg,
  lose0_75kg,
  lose0_5kg,
  lose0_25kg,
  maintain,
  gain0_25kg,
  gain0_5kg,
}

String mapWeeklyGoalToString(WeeklyGoal goal) {
  if (goal == WeeklyGoal.maintain) {
    return 'Maintain';
  } else if (goal == WeeklyGoal.gain0_25kg) {
    return 'Gain 0.25kg';
  } else if (goal == WeeklyGoal.gain0_5kg) {
    return 'Gain 0.5kg';
  } else if (goal == WeeklyGoal.lose0_25kg) {
    return 'Lose 0.25kg';
  } else if (goal == WeeklyGoal.lose0_5kg) {
    return 'Lose 0.5kg';
  } else if (goal == WeeklyGoal.lose0_75kg) {
    return 'Lose 0.75kg';
  } else if (goal == WeeklyGoal.lose1kg) {
    return 'Lose 1kg';
  }

  return '';
}

WeeklyGoal mapDatabaseStringToWeeklyGoal(String? value) {
  if (value == null) {
    return WeeklyGoal.maintain;
  } else if (value == describeEnum(WeeklyGoal.gain0_25kg)) {
    return WeeklyGoal.gain0_25kg;
  } else if (value == describeEnum(WeeklyGoal.gain0_5kg)) {
    return WeeklyGoal.gain0_5kg;
  } else if (value == describeEnum(WeeklyGoal.lose0_25kg)) {
    return WeeklyGoal.lose0_25kg;
  } else if (value == describeEnum(WeeklyGoal.lose0_5kg)) {
    return WeeklyGoal.lose0_5kg;
  } else if (value == describeEnum(WeeklyGoal.lose0_75kg)) {
    return WeeklyGoal.lose0_75kg;
  } else if (value == describeEnum(WeeklyGoal.lose1kg)) {
    return WeeklyGoal.lose1kg;
  }

  return WeeklyGoal.maintain;
}
