import 'package:bloc/bloc.dart';
import 'package:fit_tip/shared/enums/active_workout_view.dart';

class ActiveWorkoutViewSelectorCubit extends Cubit<ActiveWorkoutView> {
  ActiveWorkoutViewSelectorCubit() : super(ActiveWorkoutView.workout);

  void viewUpdatedIndex(int index) {
    emit(ActiveWorkoutView.values.elementAt(index));
  }

  void viewUpdatedEnum(ActiveWorkoutView view) {
    emit(view);
  }
}
