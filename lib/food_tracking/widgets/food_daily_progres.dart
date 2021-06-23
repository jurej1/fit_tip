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
              _Carousel(),
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

class _Carousel extends StatelessWidget {
  const _Carousel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDayProgressBloc, FoodDayProgressState>(
      builder: (context, state) {
        if (state is FoodDayProgressLoadSuccess) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 230,
              width: 210,
              child: CarouselSlider(
                items: [
                  _CarouselChild(
                    key: ValueKey('calories'),
                    title: 'Calories',
                    amount: state.calorieConsume.toStringAsFixed(0) + 'cal',
                    goal: state.calorieGoal.toStringAsFixed(0) + 'cal',
                  ),
                  _CarouselChild(
                    key: ValueKey('proteins'),
                    title: 'Proteins',
                    amount: state.proteinConsumed.toString() + 'g',
                    goal: state.proteinGoal.toString() + 'g',
                  ),
                  _CarouselChild(
                    key: ValueKey('Carbs'),
                    title: 'Carbs',
                    amount: state.carbsConsumed.toString() + 'g',
                    goal: state.carbsGoal.toString() + 'g',
                  ),
                  _CarouselChild(
                    key: ValueKey('Fats'),
                    title: 'Fats',
                    amount: state.fatsConsumed.toString() + 'g',
                    goal: state.fatsConsumed.toString() + 'g',
                  ),
                ],
                options: CarouselOptions(
                  height: 230,
                  enableInfiniteScroll: false,
                  scrollPhysics: const ClampingScrollPhysics(),
                  enlargeCenterPage: true,
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

class _CarouselChild extends StatelessWidget {
  const _CarouselChild({
    Key? key,
    required this.amount,
    required this.goal,
    required this.title,
  }) : super(key: key);

  final String amount;
  final String goal;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            amount,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Daily Goal: $goal',
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
