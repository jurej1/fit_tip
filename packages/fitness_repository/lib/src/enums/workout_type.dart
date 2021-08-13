enum WorkoutType {
  split,
  fullBody,
}

String mapWorkoutTypeToString(WorkoutType type) {
  if (type == WorkoutType.split) {
    return 'Split';
  } else if (type == WorkoutType.fullBody) {
    return 'Full body';
  }
  return '';
}
