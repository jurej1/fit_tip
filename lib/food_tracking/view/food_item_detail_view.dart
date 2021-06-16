import 'package:flutter/material.dart';

class FoodItemDetailView extends StatelessWidget {
  const FoodItemDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return FoodItemDetailView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          //DELETING FUNCTION

          //EDITING FUNCTION
        ],
      ),
      body: Column(
        children: [
          //Pie Chart with carbs, fats, and proteins
          // in the center of the pie char is going to be the amount of calories

          //NAME

          //Amount

          //DATE & TIME

          //VITAMINS
        ],
      ),
    );
  }
}
