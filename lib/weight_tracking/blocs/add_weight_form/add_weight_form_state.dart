part of 'add_weight_form_bloc.dart';

class AddWeightFormState extends Equatable {
  const AddWeightFormState({
    required this.weight,
    required this.dateAdded,
    this.status = FormzStatus.pure,
    this.errorMsg,
    this.weightModel,
    required this.timeAdded,
    this.mode = FormMode.add,
  });

  final model.Weight weight;
  final model.DateAdded dateAdded;
  final Weight? weightModel;
  final model.TimeAdded timeAdded;
  final FormMode mode;

  final FormzStatus status;
  final String? errorMsg;

  factory AddWeightFormState.initial() {
    return AddWeightFormState(
      weight: model.Weight.pure(),
      dateAdded: model.DateAdded.pure(),
      timeAdded: model.TimeAdded.pure(),
    );
  }

  factory AddWeightFormState.edit(Weight weight) {
    return AddWeightFormState(
      mode: FormMode.edit,
      weight: model.Weight.pure(weight.weight != null ? weight.weight.toString() : ''),
      dateAdded: model.DateAdded.pure(weight.date),
      timeAdded: model.TimeAdded.pure(TimeOfDay(hour: weight.date!.hour, minute: weight.date!.minute)),
      weightModel: weight,
    );
  }

  @override
  List<Object?> get props {
    return [
      weight,
      dateAdded,
      weightModel,
      timeAdded,
      status,
      errorMsg,
    ];
  }

  AddWeightFormState copyWith({
    model.Weight? weight,
    model.DateAdded? dateAdded,
    Weight? weightModel,
    model.TimeAdded? timeAdded,
    FormzStatus? status,
    String? errorMsg,
  }) {
    return AddWeightFormState(
      weight: weight ?? this.weight,
      dateAdded: dateAdded ?? this.dateAdded,
      weightModel: weightModel ?? this.weightModel,
      timeAdded: timeAdded ?? this.timeAdded,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
