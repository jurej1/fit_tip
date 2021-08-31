import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
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
    required DaySelectorBloc waterLogFocusedDayBloc,
  })  : _waterRepository = waterRepository,
        _waterLogFocusedDayBloc = waterLogFocusedDayBloc,
        super(WaterSheetTileState(cup: cup)) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final WaterRepository _waterRepository;
  final DaySelectorBloc _waterLogFocusedDayBloc;

  late final StreamSubscription _authSubscription;

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<WaterSheetTileState> mapEventToState(
    WaterSheetTileEvent event,
  ) async* {
    if (event is WaterSheetTileAddWater) {
      if (!_isAuth) {
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

        DocumentReference? ref = await _waterRepository.addWaterLog(_userId!, waterLog);

        if (ref == null) return;

        waterLog = waterLog.copyWith(id: ref.id);

        yield state.copyWith(waterLog: waterLog, status: WaterSheetTileStatus.success);
      } catch (error) {
        yield state.copyWith(status: WaterSheetTileStatus.error);
      }
    }
  }
}
