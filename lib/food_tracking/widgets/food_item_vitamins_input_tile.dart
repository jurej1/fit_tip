import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodItemVitaminsInputTile extends StatelessWidget {
  const FoodItemVitaminsInputTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Vitamins'),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AddVitaminFormBloc(),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<AddFoodItemBloc>(context),
                  )
                ],
                child: VitaminInputForm(),
              );
            },
          );
        },
      ),
    );
  }
}
