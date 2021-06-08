import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

part 'add_food_item_event.dart';
part 'add_food_item_state.dart';

class AddFoodItemBloc extends Bloc<AddFoodItemEvent, AddFoodItemState> {
  AddFoodItemBloc() : super(AddFoodItemState.pure());

  @override
  Stream<AddFoodItemState> mapEventToState(
    AddFoodItemEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
