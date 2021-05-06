import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'measurment_system_event.dart';

class MeasurmentSystemBloc extends Bloc<MeasurmentSystemEvent, MeasurmentSystem> {
  MeasurmentSystemBloc() : super(MeasurmentSystem.metric);

  @override
  Stream<MeasurmentSystem> mapEventToState(
    MeasurmentSystemEvent event,
  ) async* {
    if (event is MeasurmentSystemUpdated) {
      if (event.system != null) {
        yield event.system!;
      }
    }
  }
}
