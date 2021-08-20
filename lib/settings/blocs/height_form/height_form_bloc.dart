import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'height_form_event.dart';

class HeightFormBloc extends Bloc<HeightFormEvent, int> {
  HeightFormBloc({
    int initialValue = 160,
  }) : super(initialValue);

  @override
  Stream<int> mapEventToState(
    HeightFormEvent event,
  ) async* {
    if (event is HeightFormHeightUpdated) {
      yield event.val;
    }
  }
}
