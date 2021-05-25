import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:water_repository/water_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'water_sheet_tile_event.dart';
part 'water_sheet_tile_state.dart';

class WaterSheetTileBloc extends Bloc<WaterSheetTileEvent, WaterSheetTileState> {
  WaterSheetTileBloc({
    required WaterCup cup,
    required WaterRepository waterRepository,
    required AuthenticationBloc authenticationBloc,
  })   : _waterRepository = waterRepository,
        _authenticationBloc = authenticationBloc,
        super(WaterSheetTileState(cup: cup));

  WaterRepository _waterRepository;
  AuthenticationBloc _authenticationBloc;

  @override
  Stream<WaterSheetTileState> mapEventToState(
    WaterSheetTileEvent event,
  ) async* {
    if (event is WaterSheetTileAddWater) {
      if (!_authenticationBloc.state.isAuthenticated) {
        return;
      }

      yield state.copyWith(status: WaterSheetTileStatus.loading);

      try {
        final DateTime now = DateTime.now();
        WaterLog waterLog = WaterLog(
          id: '',
          cup: state.cup,
          time: TimeOfDay(hour: now.hour, minute: now.minute),
          date: DateTime(now.year, now.month, now.day),
        );

        DocumentReference? ref = await _waterRepository.addWaterLog(waterLog);

        if (ref == null) return;

        waterLog = waterLog.copyWith(id: ref.id);

        yield state.copyWith(waterLog: waterLog, status: WaterSheetTileStatus.success);
      } catch (error) {
        yield state.copyWith(status: WaterSheetTileStatus.error);
      }
    }
  }
}
