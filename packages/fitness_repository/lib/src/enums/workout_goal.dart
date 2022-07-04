enum WorkoutGoal {
  buildMuscle,
  loseFat,
}

extension WorkoutGoalX on WorkoutGoal {
  bool get isBuildMuscle => this == WorkoutGoal.buildMuscle;
  bool get isLoseFat => this == WorkoutGoal.loseFat;

  String toStringReadable() {
    if (isBuildMuscle) {
      return 'Build muscle';
    } else if (isLoseFat) {
      return 'Lose fat';
    }
    return '';
  }
}
