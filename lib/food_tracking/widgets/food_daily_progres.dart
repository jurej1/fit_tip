import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDailyProgress extends StatefulWidget {
  const FoodDailyProgress({Key? key}) : super(key: key);

  @override
  _FoodDailyProgressState createState() => _FoodDailyProgressState();
}

class _FoodDailyProgressState extends State<FoodDailyProgress> with SingleTickerProviderStateMixin {
  final double sizeA = 250;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<FoodDayProgressBloc, FoodDayProgressState>(
      builder: (context, state) {
        if (state is FoodDayProgressLoading) {
          return SizedBox(
            height: sizeA,
            width: size.width,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (state is FoodDayProgressFailure) {
          return Container();
        } else if (state is FoodDayProgressLoadSuccess) {
          _animationController.forward();

          return SizedBox(
            height: sizeA,
            width: size.width,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ProgressPainter(
                    maxValue: state.calorieGoal,
                    primaryValue: _animationController.value * state.calorieConsume,
                  ),
                  child: child,
                );
              },
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
