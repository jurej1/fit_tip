import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/food_tracking/models/models.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

part 'add_vitamin_form_event.dart';
part 'add_vitamin_form_state.dart';

class AddVitaminFormBloc extends Bloc<AddVitaminFormEvent, AddVitaminFormState> {
  AddVitaminFormBloc({
    double? amount,
    Vitamin? vitamin,
  }) : super(AddVitaminFormState.pure(amount: amount, vitamin: vitamin));

  @override
  Stream<AddVitaminFormState> mapEventToState(
    AddVitaminFormEvent event,
  ) async* {
    if (event is AddVitaminFormVitaminChanged) {
      yield* _mapVitaminChangedToState(event);
    } else if (event is AddVitaminFormAmountChanged) {
      yield* _mapAmountChangedToState(event);
    } else if (event is AddVitaminFormAmountFormSubmit) {
      yield* _mapSubmitToState();
    }
  }

  Stream<AddVitaminFormState> _mapVitaminChangedToState(AddVitaminFormVitaminChanged event) async* {
    if (event.vitamin != null) {
      final vitamin = VitaminInput.dirty(event.vitamin!);

      yield state.copyWith(
        vitamin: vitamin,
        status: Formz.validate([vitamin, state.amount]),
      );
    }
  }

  Stream<AddVitaminFormState> _mapAmountChangedToState(AddVitaminFormAmountChanged event) async* {
    if (event.amount != null) {
      final amount = AmountDetailConsumed.dirty(event.amount!);

      yield state.copyWith(
        amount: amount,
        status: Formz.validate([amount, state.vitamin]),
      );
    }
  }

  Stream<AddVitaminFormState> _mapSubmitToState() async* {
    final amount = AmountDetailConsumed.dirty(state.amount.value);
    final vitamin = VitaminInput.dirty(state.vitamin.value);

    yield state.copyWith(
      amount: amount,
      vitamin: vitamin,
      status: Formz.validate([amount, vitamin]),
    );

    if (state.status.isValidated) {
      FoodDataVitamin model = FoodDataVitamin(
        vitamin: state.vitamin.value,
        amount: double.parse(state.amount.value),
      );

      yield state.copyWith(
        status: FormzStatus.submissionSuccess,
        vitaminModel: model,
      );
    } else {
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
