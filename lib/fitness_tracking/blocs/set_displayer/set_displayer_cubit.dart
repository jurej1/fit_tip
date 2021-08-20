import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'set_displayer_state.dart';

class SetDisplayerCubit extends Cubit<SetDisplayerState> {
  SetDisplayerCubit({
    required int setIndex,
    required int repAmount,
    required double weightAmount,
  }) : super(
          SetDisplayerState(
            repAmount: repAmount,
            setIndex: setIndex,
            weightAmount: weightAmount,
          ),
        );

  void repAmountUpdated(int repAmount) async {
    emit(state.copyWith(repAmount: repAmount));
  }

  void weightAmountUpdated(double weightAmount) async {
    emit(state.copyWith(weightAmount: weightAmount));
  }
}
