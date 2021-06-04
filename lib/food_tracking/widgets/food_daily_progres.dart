import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDailyProgress extends StatelessWidget {
  const FoodDailyProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<FoodDayProgressBloc, FoodDayProgressState>(
      builder: (context, state) {
        if (state is FoodDayProgressLoadSuccess) {
          return SizedBox(
            height: 200,
            width: size.width,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (state is FoodDayProgressFailure) {
          return Container();
        } else if (state is FoodDayProgressLoadSuccess) {
          return SizedBox(
            height: 200,
            width: size.width,
            child: CustomPaint(
              painter: ProgressPainter(
                maxValue: state.calorieGoal,
                primaryValue: state.calorieConsume,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${state.calorieConsume.toStringAsFixed(0)}cal',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Daily Goal: ${state.calorieGoal.toStringAsFixed(0)}cal',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
