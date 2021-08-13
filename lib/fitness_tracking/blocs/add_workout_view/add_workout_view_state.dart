part of 'add_workout_view_cubit.dart';

enum AddWorkoutFormView {
  workout,
  days,
}

class AddWorkoutFormViewState extends Equatable {
  final AddWorkoutFormView view;
  final bool isVisible;

  const AddWorkoutFormViewState({
    this.view = AddWorkoutFormView.workout,
    this.isVisible = false,
  });

  @override
  List<Object> get props => [view, isVisible];

  AddWorkoutFormViewState copyWith({
    AddWorkoutFormView? view,
    bool? isVisible,
  }) {
    return AddWorkoutFormViewState(
      view: view ?? this.view,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
