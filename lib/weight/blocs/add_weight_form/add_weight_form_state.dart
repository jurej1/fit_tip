part of 'add_weight_form_bloc.dart';

class AddWeightFormState extends Equatable {
  const AddWeightFormState({
    required this.weight,
    required this.dateAdded,
    this.status = FormzStatus.pure,
    this.errorMsg,
    this.weightModel,
    required this.timeAdded,
  });

  final model.Weight weight;
  final model.DateAdded dateAdded;
  final Weight? weightModel;
  final model.TimeAdded timeAdded;

  final FormzStatus status;
  final String? errorMsg;

  factory AddWeightFormState.initial() {
    return AddWeightFormState(
      weight: model.Weight.pure(),
      dateAdded: model.DateAdded.pure(),
      timeAdded: model.TimeAdded.pure(),
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
