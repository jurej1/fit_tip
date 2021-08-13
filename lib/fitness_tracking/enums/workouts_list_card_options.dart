enum WorkoutsListCardOptions { delete, edit, setAsActive }

String mapWorkoutsListCardOptionsToString(WorkoutsListCardOptions option) {
  if (option == WorkoutsListCardOptions.delete) {
    return 'Delete';
  } else if (option == WorkoutsListCardOptions.edit) {
    return 'Edit';
  } else if (option == WorkoutsListCardOptions.setAsActive) {
    return 'Set as active';
  }
  return '';
}
