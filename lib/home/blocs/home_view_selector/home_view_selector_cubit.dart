import 'package:bloc/bloc.dart';

enum HomeViewSelectorState { excercise, food, water, weight }

class HomeViewSelectorCubit extends Cubit<HomeViewSelectorState> {
  HomeViewSelectorCubit() : super(HomeViewSelectorState.excercise);

  void valueUpdatedEnum(HomeViewSelectorState val) {
    emit(val);
  }

  void valuUpdatedIndex(int index) {
    emit(HomeViewSelectorState.values.elementAt(index));
  }
}
