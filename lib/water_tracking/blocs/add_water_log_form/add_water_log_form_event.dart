part of 'add_water_log_form_bloc.dart';

abstract class AddWaterLogFormEvent extends Equatable {
  const AddWaterLogFormEvent();

  @override
  List<Object?> get props => [];
}

class AddWaterLogFormDrinkingCupSizeChanged extends AddWaterLogFormEvent {
  final DrinkingCupSize? size;

  const AddWaterLogFormDrinkingCupSizeChanged({this.size});

  @override
  List<Object?> get props => [size];
}

class AddWaterLogFormCupAmountChanged extends AddWaterLogFormEvent {
  final double? amount;

  const AddWaterLogFormCupAmountChanged({this.amount});

  @override
  List<Object?> get props => [amount];
}

class AddWaterLogFormTimeAddedChanged extends AddWaterLogFormEvent {
  final TimeOfDay? time;

  const AddWaterLogFormTimeAddedChanged({this.time});

  @override
  List<Object?> get props => [time];
}

class AddWaterLogFormDateChanged extends AddWaterLogFormEvent {
  final DateTime? date;

  const AddWaterLogFormDateChanged({this.date});

  @override
  List<Object?> get props => [date];
}

class AddWaterLogSubmitForm extends AddWaterLogFormEvent {}
