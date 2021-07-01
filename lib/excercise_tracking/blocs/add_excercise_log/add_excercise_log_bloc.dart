import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/models/models.dart';
import 'package:formz/formz.dart';

part 'add_excercise_log_event.dart';
part 'add_excercise_log_state.dart';

class AddExcerciseLogBloc extends Bloc<AddExcerciseLogEvent, AddExcerciseLogState> {
  AddExcerciseLogBloc({
    required AuthenticationBloc authenticationBloc,
    required ActivityRepository activityRepository,
  })  : _activityRepository = activityRepository,
        _authenticationBloc = authenticationBloc,
        super(AddExcerciseLogState.initial());

  final ActivityRepository _activityRepository;
  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<AddExcerciseLogState> mapEventToState(
    AddExcerciseLogEvent event,
  ) async* {
    if (event is AddExcerciseLogDurationUpdated) {
      yield* _mapDurationUpdatedToState(event);
    }
  }

  Stream<AddExcerciseLogState> _mapDurationUpdatedToState(AddExcerciseLogDurationUpdated event) async* {
    //TODO
  }
}
