part of 'add_weight_form_bloc.dart';

abstract class AddWeightFormEvent extends Equatable {
  const AddWeightFormEvent();

  @override
  List<Object?> get props => [];
}

class AddWeightWeightChanged extends AddWeightFormEvent {
  final String value;

  const AddWeightWeightChanged(this.value);

  @override
  List<Object> get props => [value];
}

class AddWeightDateChanged extends AddWeightFormEvent {
  final DateTime? value;

  const AddWeightDateChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class AddWeightTimeChanged extends AddWeightFormEvent {
  final TimeOfDay? value;

  const AddWeightTimeChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class AddWeightFormSubit extends AddWeightFormEvent {}
