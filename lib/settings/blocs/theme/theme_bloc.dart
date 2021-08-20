import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial());

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeAccentColorUpdated) {
      yield state.copyWith(accentColor: event.value);
    } else if (event is ThemeThemeModeUpdated) {
      if (event.value != null) {
        yield state.copyWith(themeMode: event.value);
      }
    }
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState(
      themeMode: ThemeMode.values.firstWhere((element) => describeEnum(element) == json['themeMode']),
      accentColor: Color(json['accentColor']),
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {
      'themeMode': describeEnum(state.themeMode),
      'accentColor': state.accentColor.value,
    };
  }
}
