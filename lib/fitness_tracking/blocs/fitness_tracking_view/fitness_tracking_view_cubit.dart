import 'package:bloc/bloc.dart';

enum FitnessTrackingWorkoutPage { active, all }

class FitnessTrackingViewCubit extends Cubit<FitnessTrackingWorkoutPage> {
  FitnessTrackingViewCubit() : super(FitnessTrackingWorkoutPage.active);

  void viewUpdated(int index) {
    emit(FitnessTrackingWorkoutPage.values.elementAt(index));
  }

  int getActiveIndex() {
    return FitnessTrackingWorkoutPage.values.indexOf(state);
  }
}
