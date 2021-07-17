import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workouts_list_event.dart';
part 'workouts_list_state.dart';

class WorkoutsListBloc extends Bloc<WorkoutsListEvent, WorkoutsListState> {
  WorkoutsListBloc() : super(WorkoutsListInitial());

  @override
  Stream<WorkoutsListState> mapEventToState(
    WorkoutsListEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
