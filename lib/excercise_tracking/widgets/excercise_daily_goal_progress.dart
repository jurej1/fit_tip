import 'package:carousel_slider/carousel_slider.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/blocs/excercise_daily_progress/excercise_daily_progress_bloc.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExcerciseDailyGoalProgress extends StatelessWidget {
  const ExcerciseDailyGoalProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExcerciseDailyProgressBloc(
        excerciseDailyListBloc: BlocProvider.of<ExcerciseDailyListBloc>(context),
        excerciseDailyGoalBloc: BlocProvider.of<ExcerciseDailyGoalBloc>(context),
      ),
      child: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcerciseDailyProgressBloc, ExcerciseDailyProgressState>(
      builder: (context, state) {
        if (state is ExcerciseDailyProgressLoadSuccess) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      height: 210,
                      width: 210,
                      child: _Carousel(),
                    ),
                  ),
                  IgnorePointer(
                    child: SizedBox(
                      height: 250,
                      width: 250,
                      child: AnimatedProgressBar(
                        primaryValue: state.getPrimaryValue().toDouble(),
                        maxValue: state.getMaxValue().toDouble(),
                        primaryColor: state.getPrimaryColor(),
                        secondaryColor: state.getSecondaryColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else if (state is ExcerciseDailyProgressLoading) {
          return SizedBox(
            height: 220,
            width: 220,
            child: const Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class _Carousel extends StatelessWidget {
  const _Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcerciseDailyProgressBloc, ExcerciseDailyProgressState>(
      builder: (context, state) {
        if (state is ExcerciseDailyProgressLoadSuccess) {
          return CarouselSlider(
            items: [
              CarouselTile(
                amount: state.minutesWorkout.toStringAsFixed(0) + 'min',
                goal: state.goal.minutesPerDay.toStringAsFixed(0) + 'min',
                title: 'Active min',
              ),
              CarouselTile(
                amount: state.caloriesBurned.toStringAsFixed(0) + 'cal',
                goal: state.goal.caloriesBurnedPerDay.toStringAsFixed(0) + 'cal',
                title: 'Calories burned',
              ),
              CarouselTile(
                amount: state.avgMinutesPerWorkout.toStringAsFixed(0) + 'min',
                goal: state.goal.minutesPerWorkout.toStringAsFixed(0) + 'min',
                title: 'Avg workout \nduration',
              ),
            ],
            options: CarouselOptions(
              onPageChanged: (index, optins) {
                BlocProvider.of<ExcerciseDailyProgressBloc>(context).add(ExcerciseDailyProgressViewUpdated(index));
              },
              enableInfiniteScroll: false,
            ),
          );
        }
        return Container();
      },
    );
  }
}
