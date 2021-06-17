part of 'add_vitamin_form_bloc.dart';

class AddVitaminFormState extends Equatable {
  const AddVitaminFormState({
    this.status = FormzStatus.pure,
    required this.vitamin,
    required this.amount,
  });

  final FormzStatus status;
  final VitaminInput vitamin;
  final AmountDetailConsumed amount;

  factory AddVitaminFormState.pure({
    double? amount,
    Vitamin? vitamin,
  }) {
    return AddVitaminFormState(
      amount: amount == null ? AmountDetailConsumed.pure() : AmountDetailConsumed.dirty(amount.toString()),
      vitamin: vitamin == null ? VitaminInput.pure() : VitaminInput.dirty(vitamin),
    );
  }

  @override
  List<Object> get props => [status, vitamin, amount];

  AddVitaminFormState copyWith({
    FormzStatus? status,
    VitaminInput? vitamin,
    AmountDetailConsumed? amount,
  }) {
    return AddVitaminFormState(
      status: status ?? this.status,
      vitamin: vitamin ?? this.vitamin,
      amount: amount ?? this.amount,
    );
  }
}
