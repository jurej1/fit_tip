enum WorkoutType {
  split,
  fullBody,
}

extension WorkoutTypeX on WorkoutType {
  bool get isSplit => this == WorkoutType.split;
  bool get isFullBody => this == WorkoutType.fullBody;

  String toStringReadable() {
    if (isSplit) {
      return 'Split';
    } else if (isFullBody) {
      return 'Full body';
    }
    return '';
  }
}
