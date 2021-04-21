import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/functions/auth_exceptions.dart';
import 'package:fit_tip/authentication/models/models.dart';
import 'package:formz/formz.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  LoginFormBloc({
    required AuthenticationRepository authenticationRepository,
  })   : _authenticationRepository = authenticationRepository,
        super(LoginFormState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<LoginFormState> mapEventToState(
    LoginFormEvent event,
  ) async* {
    if (event is LoginEmailChanged) {
      yield _mapEmailChangedToState(event);
    } else if (event is LoginEmailUnfocused) {
      yield _mapEmailUnfocusedToState();
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event);
    } else if (event is LoginPasswordUnfocused) {
      yield _mapPasswordUnfocusedToState();
    } else if (event is LoginFormSubmit) {
      yield* _mapSubmitToState();
    }
  }

  LoginFormState _mapEmailChangedToState(LoginEmailChanged event) {
    final email = Email.dirty(event.value);

    return state.copyWith(
      email: email.invalid ? Email.pure(event.value) : email,
      status: Formz.validate([state.password, email]),
    );
  }

  LoginFormState _mapEmailUnfocusedToState() {
    final email = Email.dirty(state.email.value);

    return state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    );
  }

  LoginFormState _mapPasswordChangedToState(LoginPasswordChanged event) {
    final password = Password.dirty(event.value);

    return state.copyWith(
      password: password.invalid ? Password.pure(event.value) : password,
      status: Formz.validate([password, state.email]),
    );
  }

  LoginFormState _mapPasswordUnfocusedToState() {
    final password = Password.dirty(state.password.value);

    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.email]),
    );
  }

  Stream<LoginFormState> _mapSubmitToState() async* {
    final password = Password.dirty(state.password.value);
    final email = Email.pure(state.email.value);

    yield state.copyWith(
      password: password,
      email: email,
      status: Formz.validate([password, email]),
    );

    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      try {
        await _authenticationRepository.loginWithEmailAndPassword(email: state.email.value, password: state.password.value);

        state.copyWith(status: FormzStatus.submissionSuccess);
      } catch (e) {
        state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMsg: authExceptionToString(e.toString()),
        );
      }
    }
  }
}
