part of 'add_vitamin_form_bloc.dart';

class AddVitaminFormState extends Equatable {
  const AddVitaminFormState({
    this.status = FormzStatus.pure,
    required this.vitamin,
    required this.amount,
    this.vitaminModel,
  });

  final FormzStatus status;
  final VitaminInput vitamin;
  final AmountDetailConsumed amount;
  final FoodDataVitamin? vitaminModel;

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
  List<Object?> get props => [status, vitamin, amount, vitaminModel];

  AddVitaminFormState copyWith({
    FormzStatus? status,
    VitaminInput? vitamin,
    AmountDetailConsumed? amount,
    FoodDataVitamin? vitaminModel,
  }) {
    return AddVitaminFormState(
      status: status ?? this.status,
      vitamin: vitamin ?? this.vitamin,
      amount: amount ?? this.amount,
      vitaminModel: vitaminModel ?? this.vitaminModel,
    );
  }
}
