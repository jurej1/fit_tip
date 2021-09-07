enum WorkoutsListCardOption { setAsActive }

extension WorkoutsListCardOptionX on WorkoutsListCardOption {
  bool get isSetAsActive => this == WorkoutsListCardOption.setAsActive;

  String toStringReadable() {
    if (isSetAsActive) {
      return 'Set as active';
    }
    return '';
  }
}
