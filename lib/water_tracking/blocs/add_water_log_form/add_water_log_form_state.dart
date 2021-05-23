part of 'add_water_log_form_bloc.dart';

class AddWaterLogFormState extends Equatable {
  const AddWaterLogFormState({
    this.status = FormzStatus.pure,
  });

  final FormzStatus status;

  @override
  List<Object> get props => [
        status,
      ];
}
