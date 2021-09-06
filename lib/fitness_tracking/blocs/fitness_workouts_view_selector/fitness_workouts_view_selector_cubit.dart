import 'package:bloc/bloc.dart';

enum FitnessWorkoutsViewSelectorState {
  all,
  user,
}

extension FitnessWorkoutsViewSelectorStateX on FitnessWorkoutsViewSelectorState {
  bool get isAll => this == FitnessWorkoutsViewSelectorState.all;
  bool get isUser => this == FitnessWorkoutsViewSelectorState.user;
}

class FitnessWorkoutsViewSelectorCubit extends Cubit<FitnessWorkoutsViewSelectorState> {
  FitnessWorkoutsViewSelectorCubit() : super(FitnessWorkoutsViewSelectorState.all);

  void viewUpdatedEnum(FitnessWorkoutsViewSelectorState value) {
    emit(value);
  }

  void viewUpdatedIndex(int index) {
    emit(FitnessWorkoutsViewSelectorState.values.elementAt(index));
  }
}
