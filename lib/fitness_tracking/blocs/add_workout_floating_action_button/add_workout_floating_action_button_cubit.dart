import 'package:bloc/bloc.dart';

import '../../fitness_tracking.dart';

part 'add_workout_floating_action_button_state.dart';

class AddWorkoutFloatingActionButtonCubit extends Cubit<AddWorkoutFloatingActionButtonState> {
  AddWorkoutFloatingActionButtonCubit({
    required AddWorkoutViewCubit addWorkoutViewCubit,
  }) : super(
          addWorkoutViewCubit.state.view == AddWorkoutFormView.workout
              ? AddWorkoutFloatingActionButtonState.hidden
              : AddWorkoutFloatingActionButtonState.visible,
        );

  void pageUpdated(AddWorkoutFormView view) {
    if (view == AddWorkoutFormView.days) {
      emit(AddWorkoutFloatingActionButtonState.visible);
    } else if (view == AddWorkoutFormView.workout) {
      emit(AddWorkoutFloatingActionButtonState.hidden);
    }
  }
}
