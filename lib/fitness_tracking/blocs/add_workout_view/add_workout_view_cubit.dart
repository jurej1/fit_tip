import 'package:bloc/bloc.dart';

enum AddWorkoutFormView {
  workout,
  days,
}

class AddWorkoutViewCubit extends Cubit<AddWorkoutFormView> {
  AddWorkoutViewCubit() : super(AddWorkoutFormView.workout);

  void viewUpdated(AddWorkoutFormView view) {
    emit(view);
  }
}
