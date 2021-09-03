import 'package:bloc/bloc.dart';

enum FitnessTrackingWorkoutPage { active, all, allActive }

extension FitnessTrackingWorkoutPageX on FitnessTrackingWorkoutPage {
  bool get isActive => this == FitnessTrackingWorkoutPage.active;
  bool get isAll => this == FitnessTrackingWorkoutPage.all;
  bool get isAllActive => this == FitnessTrackingWorkoutPage.allActive;
}

class FitnessTrackingViewCubit extends Cubit<FitnessTrackingWorkoutPage> {
  FitnessTrackingViewCubit() : super(FitnessTrackingWorkoutPage.active);

  void viewUpdated(int index) {
    emit(FitnessTrackingWorkoutPage.values.elementAt(index));
  }

  int getActiveIndex() {
    return FitnessTrackingWorkoutPage.values.indexOf(state);
  }
}
