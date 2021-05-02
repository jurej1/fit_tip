part of 'add_weight_form_bloc.dart';

class AddWeightFormState extends Equatable {
  const AddWeightFormState({
    required this.weight,
    required this.dateAdded,
    this.status = FormzStatus.pure,
    this.errorMsg,
    this.weightModel,
  });

  final model.Weight weight;
  final model.DateAdded dateAdded;
  final Weight? weightModel;

  final FormzStatus status;
  final String? errorMsg;

  factory AddWeightFormState.initial() {
    return AddWeightFormState(
      weight: model.Weight.pure(),
      dateAdded: model.DateAdded.pure(),
    );
  }

  @override
  List<Object?> get props {
    return [
      weight,
      dateAdded,
      weightModel,
      status,
      errorMsg,
    ];
  }

  AddWeightFormState copyWith({
    model.Weight? weight,
    model.DateAdded? dateAdded,
    Weight? weightModel,
    FormzStatus? status,
    String? errorMsg,
  }) {
    return AddWeightFormState(
      weight: weight ?? this.weight,
      dateAdded: dateAdded ?? this.dateAdded,
      weightModel: weightModel ?? this.weightModel,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}