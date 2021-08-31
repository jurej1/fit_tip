import 'dart:async';

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
      : _foodRepository = foodRepository,
        super(FoodItemTileInitial(foodItem)) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final FoodRepository _foodRepository;
  late final StreamSubscription _authSubscription;

  String? _userId;
  bool _isAuth = false;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

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
        await _foodRepository.deleteFoodItem(_userId!, state.item);

        yield FoodItemTileDeletedSuccessfully(state.item);
      } on Exception catch (_) {
        yield FoodItemTileDeleteFail(state.item);
      }
    }
  }
}
