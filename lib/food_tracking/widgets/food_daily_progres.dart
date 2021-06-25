import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/water_tracking.dart';

class FoodDailyProgress extends StatelessWidget {
  const FoodDailyProgress();

  final double sizeA = 250;

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
          return Stack(
            alignment: Alignment.center,
            children: [
              const _Carousel(),
              IgnorePointer(
                child: SizedBox(
                  height: sizeA,
                  width: sizeA,
                  child: _AnimatedProgressBar(
                    maxValue: state.getMaxValueBasedOnView().toDouble(),
                    primaryValue: state.getPrimaryValueBasedOnView().toDouble(),
                    primaryColor: state.getPrimaryColorBasedOnView(),
                    secondaryColor: state.getSecondaryColorBasedOnView(),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                child: _SelectedViewDisplayer(),
              ),
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
          return ClipOval(
            child: Container(
              height: 230,
              width: 210,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
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
                      goal: state.fatsGoal.toString() + 'g',
                    ),
                  ],
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      BlocProvider.of<FoodDayProgressBloc>(context).add(FoodDayProgressSelectedViewUpdated(index));
                    },
                    height: 230,
                    enableInfiniteScroll: false,
                    scrollPhysics: const ClampingScrollPhysics(),
                    enlargeCenterPage: true,
                  ),
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

class _SelectedViewDisplayer extends StatefulWidget {
  const _SelectedViewDisplayer({Key? key}) : super(key: key);

  @override
  __SelectedViewDisplayerState createState() => __SelectedViewDisplayerState();
}

class __SelectedViewDisplayerState extends State<_SelectedViewDisplayer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final double dotSize = 10;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: FoodDayProgressCarouselView.values.length.toDouble(),
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
    return BlocConsumer<FoodDayProgressBloc, FoodDayProgressState>(
      listener: (context, state) {
        if (state is FoodDayProgressLoadSuccess) {
          _animationController.animateTo(state.getSelectedViewIndex());
        }
      },
      builder: (context, state) {
        if (state is FoodDayProgressLoadSuccess) {
          return Container(
            width: 80,
            height: 15,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    FoodDayProgressCarouselView.values.length,
                    (index) {
                      return Container(
                        height: dotSize,
                        width: dotSize,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) {
                    return Positioned(
                      left: 23.333 * _animationController.value,
                      child: AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 250),
                        height: dotSize,
                        width: dotSize,
                        decoration: BoxDecoration(
                          color: state.getPrimaryColorBasedOnView(),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}

class _AnimatedProgressBar extends StatefulWidget {
  const _AnimatedProgressBar({
    Key? key,
    required this.primaryValue,
    required this.maxValue,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  final double primaryValue;
  final double maxValue;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  __AnimatedProgressBarState createState() => __AnimatedProgressBarState();
}

class __AnimatedProgressBarState extends State<_AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
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
    _animationController.reset();
    _animationController.forward();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: ProgressPainter(
            innerColor: widget.primaryColor,
            outerColor: widget.secondaryColor,
            maxValue: widget.maxValue,
            primaryValue: _animationController.value * widget.primaryValue,
          ),
          child: child,
        );
      },
    );
  }
}
