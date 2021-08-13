import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_workout_view_state.dart';

class AddWorkoutViewCubit extends Cubit<AddWorkoutFormViewState> {
  AddWorkoutViewCubit() : super(AddWorkoutFormViewState());

  void viewUpdated(AddWorkoutFormView view) {
    emit(state.copyWith(view: view));
  }

  void viewIndexUpdated(int index) {
    emit(state.copyWith(view: AddWorkoutFormView.values.elementAt(index)));
  }

  void workoutsPerWeekAmountUpdated(int amount) {
    if (amount == 0 || amount.isNaN) {
      emit(state.copyWith(isVisible: false));
    } else {
      emit(state.copyWith(isVisible: true));
    }
  }
}
