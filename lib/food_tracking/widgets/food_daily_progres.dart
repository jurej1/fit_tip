import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/water_tracking.dart';

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

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 230,
                width: 210,
                child: CarouselSlider(
                  items: [],
                  options: CarouselOptions(
                    height: 200,
                    pageSnapping: true,
                    enlargeCenterPage: true,
                  ),
                ),
              ),
              IgnorePointer(
                child: SizedBox(
                  height: sizeA,
                  width: sizeA,
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
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                child: Container(
                  width: 100,
                  height: 15,
                  color: Colors.red,
                ),
              )
            ],
          );
        }

        return Container();
      },
    );
  }
}

class _CarouselChild extends StatelessWidget {
  const _CarouselChild({
    Key? key,
    required this.calAmount,
    required this.dailyGoal,
  }) : super(key: key);

  final String calAmount;
  final String dailyGoal;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${calAmount}cal',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Daily Goal: ${dailyGoal}cal',
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
