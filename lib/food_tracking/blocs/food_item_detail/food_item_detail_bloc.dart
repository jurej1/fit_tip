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
  })  : _foodRepository = foodRepository,
        super(FoodItemDetailInitial(foodItem)) {
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

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

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

        await _foodRepository.deleteFoodItem(_userId!, state.item);

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
