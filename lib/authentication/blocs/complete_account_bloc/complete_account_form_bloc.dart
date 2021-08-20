import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';

part 'complete_account_form_event.dart';
part 'complete_account_form_state.dart';

class CompleteAccountFormBloc extends Bloc<CompleteAccountFormEvent, CompleteAccountFormState> {
  CompleteAccountFormBloc({
    required AuthenticationBloc authenticationBloc,
  }) : super(CompleteAccountFormState());

  @override
  Stream<CompleteAccountFormState> mapEventToState(
    CompleteAccountFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
