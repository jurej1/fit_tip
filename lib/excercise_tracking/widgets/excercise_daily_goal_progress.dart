import 'package:carousel_slider/carousel_slider.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/blocs/excercise_daily_progress/excercise_daily_progress_bloc.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExcerciseDailyGoalProgress extends StatelessWidget {
  const ExcerciseDailyGoalProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExcerciseDailyProgressBloc(
            excerciseDailyListBloc: BlocProvider.of<ExcerciseDailyListBloc>(context),
            excerciseDailyGoalBloc: BlocProvider.of<ExcerciseDailyGoalBloc>(context),
          ),
        ),
        BlocProvider(
          create: (context) => PageControllerCubit(),
        )
      ],
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
                  Positioned(
                    bottom: 15,
                    child: _SelectedViewDisplayer(),
                  )
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

class _Carousel extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _pageController = usePageController();

    _pageController.addListener(() {
      final double page = _pageController.page ?? 0.0;
      BlocProvider.of<PageControllerCubit>(context).scrollUpdated(page);
      BlocProvider.of<ExcerciseDailyProgressBloc>(context).add(ExcerciseDailyProgressViewUpdated(page.round()));
    });

    return BlocBuilder<ExcerciseDailyProgressBloc, ExcerciseDailyProgressState>(
      builder: (context, state) {
        if (state is ExcerciseDailyProgressLoadSuccess) {
          return PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            children: [
              PageViewTile(
                amount: state.minutesPerDay.toStringAsFixed(0) + 'min',
                goal: state.goal.minutesPerDay.toStringAsFixed(0) + 'min',
                title: 'Active min',
              ),
              PageViewTile(
                amount: state.caloriesBurnedPerDay.toStringAsFixed(0) + 'cal',
                goal: state.goal.caloriesBurnedPerDay.toStringAsFixed(0) + 'cal',
                title: 'Calories burned',
              ),
              PageViewTile(
                amount: state.avgMinutesPerWorkout.toStringAsFixed(0) + 'min',
                goal: state.goal.minutesPerWorkout.toStringAsFixed(0) + 'min',
                title: 'Avg workout \nduration',
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class _SelectedViewDisplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageControllerCubit, double>(
      builder: (contex, state) {
        return CustomPaint(
          painter: SelectedViewPainter(
            length: 3,
            dotBorderThicknes: 1,
            dotBorderColor: Colors.grey.shade500,
            radius: 7,
            spacing: 20,
            scrollPosition: state,
            dotBackgroundColor: Colors.grey.shade300,
            indicatorColor: Colors.blue,
          ),
        );
      },
    );
  }
}
