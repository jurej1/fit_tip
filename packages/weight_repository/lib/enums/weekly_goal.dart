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
