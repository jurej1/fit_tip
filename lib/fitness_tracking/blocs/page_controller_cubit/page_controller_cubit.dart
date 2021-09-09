import 'package:bloc/bloc.dart';

class PageControllerCubit extends Cubit<double> {
  PageControllerCubit() : super(0.0);

  void scrollUpdated(double scrollOffset) {
    emit(scrollOffset);
  }
}
