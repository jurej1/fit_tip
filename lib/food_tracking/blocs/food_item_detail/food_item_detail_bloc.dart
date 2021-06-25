import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:food_repository/food_repository.dart';

part 'food_item_detail_event.dart';
part 'food_item_detail_state.dart';

class FoodItemDetailBloc extends Bloc<FoodItemDetailEvent, FoodItemDetailState> {
  FoodItemDetailBloc({
    required FoodItem foodItem,
    required AuthenticationBloc authenticationBloc,
    required FoodRepository foodRepository,
  })   : _foodRepository = foodRepository,
        _authenticationBloc = authenticationBloc,
        super(FoodItemDetailInitial(foodItem));

  final FoodRepository _foodRepository;
  final AuthenticationBloc _authenticationBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<FoodItemDetailState> mapEventToState(
    FoodItemDetailEvent event,
  ) async* {
    if (event is FoodItemDetailDeleteRequested) {
      yield* _mapDeleteRequestedToState();
    } else if (event is FoodItemDetailUpdated) {
      yield* _mapUpdatedToState(event);
    }
  }

  Stream<FoodItemDetailState> _mapDeleteRequestedToState() async* {
    if (_isAuth) {
      try {
        yield FoodItemDetailLoading(state.item);

        await _foodRepository.deleteFoodItem(_user!.id!, state.item);

        yield FoodItemDetailDeleteSuccess(state.item);
      } catch (e) {
        yield FoodItemDetailDeleteFail(state.item);
      }
    }
  }

  Stream<FoodItemDetailState> _mapUpdatedToState(FoodItemDetailUpdated event) async* {
    if (_isAuth && event.foodItem != null) {
      yield FoodItemDetailInitial(event.foodItem!);
    }
  }
}
