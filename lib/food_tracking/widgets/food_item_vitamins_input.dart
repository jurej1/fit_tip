import 'package:flutter/material.dart';

class FoodItemVitaminsInput extends StatelessWidget {
  const FoodItemVitaminsInput({Key? key}) : super(key: key);

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
              return Container();
            },
          );
        },
      ),
    );
  }
}
