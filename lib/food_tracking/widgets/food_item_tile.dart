import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodItemTile extends StatelessWidget {
  const FoodItemTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: BlocBuilder<FoodItemTileBloc, FoodItemTileState>(
        buildWhen: (p, c) => p.item.name != c.item.name,
        builder: (context, state) {
          return Text(state.item.name);
        },
      ),
      subtitle: BlocBuilder<FoodItemTileBloc, FoodItemTileState>(
        buildWhen: (p, c) {
          if (p.item.calories != c.item.calories) {
            return true;
          }

          if (p.item.amount != c.item.amount) {
            return true;
          }

          return false;
        },
        builder: (context, state) {
          final item = state.item;
          return Text('${item.calories}cal - ${item.amount}g');
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          BlocProvider.of<FoodItemTileBloc>(context).add(FoodItemTileDeleteRequested());
        },
      ),
    );
  }
}
