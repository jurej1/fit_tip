import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/blocs/food_item_detail/food_item_detail_bloc.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:intl/intl.dart';

class FoodItemDetailView extends StatelessWidget {
  const FoodItemDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(
    BuildContext context, {
    required FoodItem item,
  }) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<FoodDailyLogsBloc>(context),
            ),
            BlocProvider(
              create: (context) => FoodItemDetailBloc(
                foodItem: item,
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                foodRepository: RepositoryProvider.of<FoodRepository>(context),
              ),
            ),
          ],
          child: FoodItemDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodItemDetailBloc, FoodItemDetailState>(
      listener: (context, state) {
        if (state is FoodItemDetailDeleteSuccess) {
          BlocProvider.of<FoodDailyLogsBloc>(context).add(FoodDailyLogsLogRemoved(foodItem: state.item));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail view'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                BlocProvider.of<FoodItemDetailBloc>(context).add(FoodItemDetailDeleteRequested());
              },
            ),
            //EDITING FUNCTION
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  AddFoodLogView.route(
                    context,
                    fooditemDetailBloc: BlocProvider.of<FoodItemDetailBloc>(context),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              //Pie Chart with carbs, fats, and proteins
              // in the center of the pie char is going to be the amount of calories
              Container(
                height: 200,
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: FoodItemDetailPieChart(),
                    ),
                    Expanded(
                      child: FoodItemMacrosData(),
                    ),
                  ],
                ),
              ),
              FoodItemData(),

              //Amount

              //DATE & TIME

              //VITAMINS
            ],
          ),
        ),
      ),
    );
  }
}

class FoodItemDetailPieChart extends StatelessWidget {
  const FoodItemDetailPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodItemDetailBloc, FoodItemDetailState>(
      builder: (context, state) {
        if (state.item.macronutrients == null) {
          return Center(
            child: Text(
              state.item.calories.toStringAsFixed(0) + 'cal',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          );
        }

        return CustomPaint(
          painter: FoodItemMacrosPieChartPainter(
            carbsAmount: state.item.macronutrients!.firstWhere((e) => e.macronutrient == Macronutrient.carbs).amount,
            fatAmount: state.item.macronutrients!.firstWhere((e) => e.macronutrient == Macronutrient.fat).amount,
            proteinAmount: state.item.macronutrients!.firstWhere((e) => e.macronutrient == Macronutrient.protein).amount,
          ),
          child: Center(
            child: Text(
              state.item.calories.toStringAsFixed(0) + 'cal',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

class FoodItemMacrosData extends StatelessWidget {
  FoodItemMacrosData({Key? key}) : super(key: key);

  final inputDecorationStyle = InputDecoration(border: InputBorder.none);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodItemDetailBloc, FoodItemDetailState>(
      builder: (context, state) {
        if (state.item.macronutrients == null) return Container();

        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.item.macronutrients!.map((e) {
              return TextFormField(
                key: ValueKey(e.amount),
                initialValue: e.amount.toStringAsFixed(0) + 'g',
                enabled: false,
                decoration: inputDecorationStyle.copyWith(
                  labelText: macronutrientToString(e.macronutrient),
                  labelStyle: TextStyle(
                    color: mapMacronutrientToColor(e.macronutrient),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Color mapMacronutrientToColor(Macronutrient a) {
    if (a == Macronutrient.fat) {
      return Colors.red;
    } else if (a == Macronutrient.carbs) {
      return Colors.blue;
    } else if (a == Macronutrient.protein) {
      return Colors.green;
    }
    return Colors.grey;
  }
}

class FoodItemData extends StatelessWidget {
  FoodItemData({Key? key}) : super(key: key);

  final inputDecorationStyle = InputDecoration(border: InputBorder.none);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodItemDetailBloc, FoodItemDetailState>(
      builder: (context, state) {
        return Container(
          child: Column(
            children: [
              TextFormField(
                key: ValueKey(state.item.name),
                initialValue: state.item.name,
                enabled: false,
                decoration: inputDecorationStyle.copyWith(labelText: 'Name'),
              ),
              TextFormField(
                key: ValueKey(state.item.amount),
                initialValue: state.item.amount.toString() + 'g',
                enabled: false,
                decoration: inputDecorationStyle.copyWith(labelText: 'Amount'),
              ),
              TextFormField(
                key: ValueKey(state.item.dateAdded),
                initialValue: DateFormat('d.MMM.yyyy').format(state.item.dateAdded),
                enabled: false,
                decoration: inputDecorationStyle.copyWith(labelText: 'Date added'),
              ),
              TextFormField(
                key: ValueKey(DateFormat('HH:mm').format(state.item.dateAdded)),
                initialValue: DateFormat('HH:mm').format(state.item.dateAdded),
                enabled: false,
                decoration: inputDecorationStyle.copyWith(labelText: 'Time added'),
              ),
            ],
          ),
        );
      },
    );
  }
}
