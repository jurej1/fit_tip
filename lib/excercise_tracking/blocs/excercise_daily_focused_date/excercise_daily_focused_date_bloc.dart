import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'excercise_daily_focused_date_event.dart';
part 'excercise_daily_focused_date_state.dart';

class ExcerciseDailyFocusedDateBloc extends Bloc<ExcerciseDailyFocusedDateEvent, ExcerciseDailyFocusedDateState> {
  ExcerciseDailyFocusedDateBloc() : super(ExcerciseDailyFocusedDateState(DateTime.now()));

  @override
  Stream<ExcerciseDailyFocusedDateState> mapEventToState(
    ExcerciseDailyFocusedDateEvent event,
  ) async* {}
}
