import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodItemTile extends StatelessWidget {
  const FoodItemTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodItemTileBloc, FoodItemTileState>(
      listener: (context, state) {
        if (state is FoodItemTileDeletedSuccessfully) {
          BlocProvider.of<FoodDailyLogsBloc>(context).add(FoodDailyLogsLogRemoved(foodItem: state.item));
        }
      },
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            FoodItemDetailView.route(
              context,
              // foodDailyLogsBloc: BlocProvider.of<FoodDailyLogsBloc>(context),
              item: BlocProvider.of<FoodItemTileBloc>(context).state.item,
            ),
          );
        },
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
        trailing: BlocBuilder<FoodItemTileBloc, FoodItemTileState>(
          builder: (context, state) {
            return IconButton(
              icon: state is FoodItemTileLoading
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const CircularProgressIndicator(),
                    )
                  : const Icon(Icons.delete),
              onPressed: () {
                BlocProvider.of<FoodItemTileBloc>(context).add(FoodItemTileDeleteRequested());
              },
            );
          },
        ),
      ),
    );
  }
}
