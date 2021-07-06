import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_tip/food_tracking/blocs/blocs.dart';

import 'widgets.dart';

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
                  child: AnimatedProgressBar(
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
                    CarouselTile(
                      key: ValueKey('calories'),
                      title: 'Calories',
                      amount: state.calorieConsume.toStringAsFixed(0) + 'cal',
                      goal: state.calorieGoal.toStringAsFixed(0) + 'cal',
                    ),
                    CarouselTile(
                      key: ValueKey('proteins'),
                      title: 'Proteins',
                      amount: state.proteinConsumed.toString() + 'g',
                      goal: state.proteinGoal.toString() + 'g',
                    ),
                    CarouselTile(
                      key: ValueKey('Carbs'),
                      title: 'Carbs',
                      amount: state.carbsConsumed.toString() + 'g',
                      goal: state.carbsGoal.toString() + 'g',
                    ),
                    CarouselTile(
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
          return SelectedViewDisplayer(
            dotSize: dotSize,
            length: FoodDayProgressCarouselView.values.length,
            controller: _animationController,
            selectedColor: state.getPrimaryColorBasedOnView(),
          );
        }

        return Container();
      },
    );
  }
}
