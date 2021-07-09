import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum AddWorkoutFormView {
  workout,
  days,
}

class AddWorkoutViewCubit extends Cubit<AddWorkoutFormView> {
  AddWorkoutViewCubit() : super(AddWorkoutFormView.workout);

  void viewUpdated(int index) {
    emit(AddWorkoutFormView.values.elementAt(index));
  }
}
