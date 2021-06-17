part of 'add_vitamin_form_bloc.dart';

abstract class AddVitaminFormEvent extends Equatable {
  const AddVitaminFormEvent();

  @override
  List<Object?> get props => [];
}

class AddVitaminFormVitaminChanged extends AddVitaminFormEvent {
  final Vitamin? vitamin;

  AddVitaminFormVitaminChanged({this.vitamin});

  @override
  List<Object?> get props => [vitamin];
}

class AddVitaminFormAmountChanged extends AddVitaminFormEvent {
  final String? amount;

  AddVitaminFormAmountChanged({this.amount});

  @override
  List<Object?> get props => [amount];
}

class AddVitaminFormAmountFormSubmit extends AddVitaminFormEvent {}
