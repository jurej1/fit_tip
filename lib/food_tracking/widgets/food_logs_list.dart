import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

class FoodLogsList extends StatelessWidget {
  FoodLogsList({
    Key? key,
    List<FoodItem>? foods,
  })  : _foods = foods ?? const [],
        super(key: key);

  final List<FoodItem> _foods;

  @override
  Widget build(BuildContext context) {
    if (_foods.isEmpty) return Container();

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: _foods.length,
      itemBuilder: (context, index) {
        final item = _foods[index];

        return BlocProvider(
          create: (context) => FoodItemTileBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            foodItem: item,
            foodRepository: RepositoryProvider.of<FoodRepository>(context),
          ),
          child: FoodItemTile(),
        );
      },
    );
  }
}
