import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:food_repository/food_repository.dart';

part 'food_item_tile_event.dart';
part 'food_item_tile_state.dart';

class FoodItemTileBloc extends Bloc<FoodItemTileEvent, FoodItemTileState> {
  FoodItemTileBloc(
      {required FoodItem foodItem,
      required FoodRepository foodRepository,
      required AuthenticationBloc authenticationBloc,
      int? caloriegoal})
      : _authenticationBloc = authenticationBloc,
        _foodRepository = foodRepository,
        super(FoodItemTileInitial(foodItem));

  final AuthenticationBloc _authenticationBloc;
  final FoodRepository _foodRepository;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<FoodItemTileState> mapEventToState(
    FoodItemTileEvent event,
  ) async* {
    if (event is FoodItemTileDeleteRequested) {
      yield* _mapDeleteRequestedToState();
    }
  }

  Stream<FoodItemTileState> _mapDeleteRequestedToState() async* {
    if (_isAuth) {
      yield FoodItemTileLoading(state.item);

      try {
        await _foodRepository.deleteFoodItem(_user!.id!, state.item);

        yield FoodItemTileDeletedSuccessfully(state.item);
      } on Exception catch (_) {
        yield FoodItemTileDeleteFail(state.item);
      }
    }
  }
}
