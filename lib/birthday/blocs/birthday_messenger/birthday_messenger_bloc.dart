import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';

part 'birthday_messenger_event.dart';

class BirthdayMessengerBloc extends Bloc<BirthdayMessengerEvent, bool> {
  BirthdayMessengerBloc({
    required AuthenticationBloc authenticationBloc,
  }) : super(false) {
    _streamSubscription = authenticationBloc.stream.listen((event) {
      add(_BirthdayMessengerUserUpdated(event.user));
    });
  }

  late final StreamSubscription _streamSubscription;

  @override
  Stream<bool> mapEventToState(
    BirthdayMessengerEvent event,
  ) async* {
    if (event is _BirthdayMessengerUserUpdated) {
      if (event.user != null && event.user!.birthdate != null) {
        final birthday = event.user!.birthdate!;
        final now = DateTime.now();

        yield birthday.day == now.day && birthday.month == now.month;
      } else {
        yield false;
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
