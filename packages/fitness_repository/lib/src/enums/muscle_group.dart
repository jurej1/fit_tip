enum MuscleGroup {
  chest,
  back,
  arms,
  abdominals,
  legs,
  shoulders,
  wholeBody,
}

String mapMuscleGroupToString(MuscleGroup group) {
  if (group == MuscleGroup.chest) return 'Chest';
  if (group == MuscleGroup.abdominals) return 'Abdominals';
  if (group == MuscleGroup.arms) return 'Arms';
  if (group == MuscleGroup.back) return 'Back';
  if (group == MuscleGroup.legs) return 'Legs';
  if (group == MuscleGroup.shoulders) return 'Shoulders';
  if (group == MuscleGroup.wholeBody) return 'Whole Body';

  return '';
}
