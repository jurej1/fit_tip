part of 'complete_account_form_bloc.dart';

abstract class CompleteAccountFormEvent extends Equatable {
  const CompleteAccountFormEvent();

  @override
  List<Object?> get props => [];
}

class _CompleteAccountFormUserUpdated extends CompleteAccountFormEvent {
  final User? user;

  const _CompleteAccountFormUserUpdated(this.user);
  @override
  List<Object?> get props => [user];
}

class CompleteAccountFormFirstNameUpdated extends CompleteAccountFormEvent {
  final String value;

  const CompleteAccountFormFirstNameUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class CompleteAccountFormLastNameUpdated extends CompleteAccountFormEvent {
  final String value;

  const CompleteAccountFormLastNameUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class CompleteAccountFormDisplayNameUpdated extends CompleteAccountFormEvent {
  final String value;

  const CompleteAccountFormDisplayNameUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class CompleteAccountFormIntroductionUpdated extends CompleteAccountFormEvent {
  final String value;

  const CompleteAccountFormIntroductionUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class CompleteAccountFormBirthdateUpdated extends CompleteAccountFormEvent {
  final DateTime value;

  const CompleteAccountFormBirthdateUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class CompleteAccountFormGenderUpdated extends CompleteAccountFormEvent {
  final Gender? value;

  const CompleteAccountFormGenderUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class CompleteAccountFormMeasurmentSystemUpdated extends CompleteAccountFormEvent {
  final MeasurmentSystem? value;

  const CompleteAccountFormMeasurmentSystemUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class CompleteAccountFormHeightUpdated extends CompleteAccountFormEvent {
  final double? value;

  const CompleteAccountFormHeightUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class CompleteAccountFormSubmit extends CompleteAccountFormEvent {}
