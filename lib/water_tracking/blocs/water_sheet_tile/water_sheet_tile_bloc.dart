import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart' as rep;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:water_repository/water_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'water_sheet_tile_event.dart';
part 'water_sheet_tile_state.dart';

class WaterSheetTileBloc extends Bloc<WaterSheetTileEvent, WaterSheetTileState> {
  WaterSheetTileBloc({
    required WaterCup cup,
    required WaterRepository waterRepository,
    required AuthenticationBloc authenticationBloc,
    required WaterLogFocusedDayBloc waterLogFocusedDayBloc,
  })   : _waterRepository = waterRepository,
        _waterLogFocusedDayBloc = waterLogFocusedDayBloc,
        _authenticationBloc = authenticationBloc,
        super(WaterSheetTileState(cup: cup));

  final WaterRepository _waterRepository;
  final AuthenticationBloc _authenticationBloc;
  final WaterLogFocusedDayBloc _waterLogFocusedDayBloc;

  bool get isAuth => _authenticationBloc.state.isAuthenticated;
  rep.User? get user => _authenticationBloc.state.user;

  @override
  Stream<WaterSheetTileState> mapEventToState(
    WaterSheetTileEvent event,
  ) async* {
    if (event is WaterSheetTileAddWater) {
      if (!isAuth) {
        return;
      }

      yield state.copyWith(status: WaterSheetTileStatus.loading);

      try {
        final DateTime now = DateTime.now();
        final DateTime selectedDate = _waterLogFocusedDayBloc.state.selectedDate;

        WaterLog waterLog = WaterLog(
          id: '',
          cup: state.cup,
          time: TimeOfDay(hour: now.hour, minute: now.minute),
          date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
        );

        DocumentReference? ref = await _waterRepository.addWaterLog(user!.id!, waterLog);

        if (ref == null) return;

        waterLog = waterLog.copyWith(id: ref.id);

        yield state.copyWith(waterLog: waterLog, status: WaterSheetTileStatus.success);
      } catch (error) {
        yield state.copyWith(status: WaterSheetTileStatus.error);
      }
    }
  }
}
