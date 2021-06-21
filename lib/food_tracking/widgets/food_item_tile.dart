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
      child: Material(
        child: ListTile(
          dense: true,
          onTap: () {
            Navigator.of(context).push(
              FoodItemDetailView.route(
                context,
                item: BlocProvider.of<FoodItemTileBloc>(context).state.item,
              ),
            );
          },
          title: BlocBuilder<FoodItemTileBloc, FoodItemTileState>(
            builder: (context, state) {
              return Text(state.item.name);
            },
          ),
          subtitle: BlocBuilder<FoodItemTileBloc, FoodItemTileState>(
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
      ),
    );
  }
}
