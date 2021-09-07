import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'active_workout_id_event.dart';

class ActiveWorkoutIdBloc extends HydratedBloc<ActiveWorkoutIdEvent, String?> {
  ActiveWorkoutIdBloc() : super(null);

  @override
  Stream<String?> mapEventToState(
    ActiveWorkoutIdEvent event,
  ) async* {
    if (event is ActiveWorkoutIdUpdated) {
      yield event.id;
    }
  }

  @override
  String? fromJson(Map<String, dynamic> json) {
    return json['value'];
  }

  @override
  Map<String, dynamic>? toJson(String? state) {
    return {'value': state};
  }
}
