enum WorkoutGoal {
  buildMuscle,
  loseFat,
  inscreaseStrength,
}

String mapWorkoutGoalToText(WorkoutGoal goal) {
  if (goal == WorkoutGoal.buildMuscle) {
    return 'Build muscle';
  } else if (goal == WorkoutGoal.inscreaseStrength) {
    return 'Increase strength';
  } else if (goal == WorkoutGoal.loseFat) {
    return 'Lose fat';
  }
  return '';
}
