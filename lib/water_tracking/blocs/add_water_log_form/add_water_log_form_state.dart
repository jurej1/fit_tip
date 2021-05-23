part of 'add_water_log_form_bloc.dart';

class AddWaterLogFormState extends Equatable {
  AddWaterLogFormState._({
    this.status = FormzStatus.pure,
    this.waterCupInput = const WaterCupInput.pure(),
    required this.timeAdded,
    required this.dateAdded,
  });

  final FormzStatus status;
  final WaterCupInput waterCupInput;
  final DateAdded dateAdded;
  final TimeAdded timeAdded;

  factory AddWaterLogFormState.pure() {
    return AddWaterLogFormState._(
      dateAdded: DateAdded.pure(),
      timeAdded: TimeAdded.pure(),
    );
  }

  @override
  List<Object> get props => [status, waterCupInput, dateAdded, timeAdded];

  AddWaterLogFormState copyWith({
    FormzStatus? status,
    WaterCupInput? waterCupInput,
    DateAdded? dateAdded,
    TimeAdded? timeAdded,
  }) {
    return AddWaterLogFormState._(
      status: status ?? this.status,
      waterCupInput: waterCupInput ?? this.waterCupInput,
      dateAdded: dateAdded ?? this.dateAdded,
      timeAdded: timeAdded ?? this.timeAdded,
    );
  }
}
