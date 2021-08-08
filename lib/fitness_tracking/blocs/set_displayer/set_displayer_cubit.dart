import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'set_displayer_state.dart';

class SetDisplayerCubit extends Cubit<SetDisplayerState> {
  SetDisplayerCubit({
    required int setIndex,
  }) : super(
          SetDisplayerState(
            repAmount: 10,
            setIndex: setIndex,
            weightAmount: 50,
          ),
        );

  void repAmountUpdated(int repAmount) {
    emit(state.copyWith(repAmount: repAmount));
  }

  void weightAmountUpdated(double weightAmount) {
    emit(state.copyWith(weightAmount: weightAmount));
  }
}
