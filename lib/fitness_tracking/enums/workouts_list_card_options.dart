enum WorkoutsListCardOption { delete, edit, setAsActive }

extension WorkoutsListCardOptionX on WorkoutsListCardOption {
  bool get isDelete => this == WorkoutsListCardOption.delete;
  bool get isEdit => this == WorkoutsListCardOption.edit;
  bool get isSetAsActive => this == WorkoutsListCardOption.setAsActive;

  String toStringReadable() {
    if (isDelete) {
      return 'Delete';
    } else if (isEdit) {
      return 'Edit';
    } else if (isSetAsActive) {
      return 'Set as active';
    }
    return '';
  }
}
