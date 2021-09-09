import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../fitness_tracking.dart';

class ActiveWorkoutBuilder extends StatelessWidget {
  const ActiveWorkoutBuilder({Key? key}) : super(key: key);

  static Widget route() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PageControllerCubit(),
        ),
        BlocProvider(
          create: (context) => TableCalendarBloc(
            activeWorkoutBloc: BlocProvider.of<ActiveWorkoutBloc>(context),
          ),
        ),
        BlocProvider(
          create: (context) => FocusedWorkoutDayBloc(
            activeWorkoutBloc: BlocProvider.of<ActiveWorkoutBloc>(context),
            tableCalendarBloc: BlocProvider.of<TableCalendarBloc>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
          ),
        ),
      ],
      child: ActiveWorkoutBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ActiveWorkoutBloc, ActiveWorkoutState>(
          listener: (context, state) {
            if (state is ActiveWorkoutLoadSuccess) {
              BlocProvider.of<TableCalendarBloc>(context).add(TableCalendarWorkoutUpdated(state.workout));
            }
          },
        ),
        BlocListener<TableCalendarBloc, TableCalendarState>(
          listener: (context, state) {
            if (state is TableCalendarLoadSuccess) {
              BlocProvider.of<FocusedWorkoutDayBloc>(context).add(FocusedWorkoutDayDateUpdated(state.focusedDay));
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fitness tracking'),
              _AppBarPageDisplayer(),
            ],
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add),
          //     onPressed: () {
          //       Navigator.of(context).push(AddWorkoutView.route(context));
          //     },
          //   ),
          //   BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
          //     builder: (context, state) {
          //       if (state is ActiveWorkoutLoadSuccess) {
          //         return IconButton(
          //           icon: const Icon(Icons.edit),
          //           onPressed: () {
          //             //TODO editing active workout
          //             // Navigator.of(context).push(AddWorkoutView.route(context, workout: state.workout));
          //           },
          //         );
          //       }
          //       return Container();
          //     },
          //   ),
          // ],
        ),
        body: _bodyBuilder(),
        bottomNavigationBar: FitnessTrackingViewSelector(),
        floatingActionButton: _fabBuilder(),
      ),
    );
  }

  Widget _fabBuilder() {
    return BlocBuilder<FocusedWorkoutDayBloc, FocusedWorkoutDayState>(
      builder: (context, state) {
        if (state is FocusedWorkoutDayLoadSuccess) {
          return FloatingActionButton.extended(
            onPressed: () {
              if (state.workoutDay == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('You do not have any workouts today')));
              } else {
                if (state.isWorkoutCompleted == false) {
                  Navigator.of(context).push(
                    RunningWorkoutDayView.route(
                      context,
                      state.workoutDay!,
                      state.date,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('You allready completed a workout')));
                }
              }
            },
            label: const Text('Start Workout'),
          );
        }

        return Container();
      },
    );
  }

  Widget _bodyBuilder() {
    return BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, state) {
        if (state is ActiveWorkoutLoading) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is ActiveWorkoutLoadSuccess) {
          return _PageViewBuilder();
        } else if (state is ActiveWorkoutNone) {
          return Center(
            child: Text('You don not have any active workout'),
          );
        }

        return Container();
      },
    );
  }
}

class _PageViewBuilder extends HookWidget {
  const _PageViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageController = usePageController();
    _pageController.addListener(() {
      BlocProvider.of<PageControllerCubit>(context).scrollUpdated(_pageController.page ?? 0.0);
    });

    return PageView(
      controller: _pageController,
      physics: const BouncingScrollPhysics(),
      children: [
        const ActiveWorkoutOverviewBuilder(),
        const CalanderAndWokroutDayBuilder(),
        const WorkoutDayLogsBuilder(),
      ],
      onPageChanged: (index) {
        BlocProvider.of<ActiveWorkoutViewSelectorCubit>(context).viewUpdatedIndex(index);
      },
    );
  }
}

class _AppBarPageDisplayer extends HookWidget {
  const _AppBarPageDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageControllerCubit, double>(
      builder: (context, state) {
        return CustomPaint(
          painter: SelectedViewPainter(
            scrollPosition: state,
            dotBackgroundColor: Colors.grey.shade200,
            length: ActiveWorkoutView.values.length,
            radius: 8,
            spacing: 15,
            dotBorderColor: Colors.grey,
            dotBorderThicknes: 1,
            indicatorColor: Colors.blue,
          ),
        );
      },
    );
  }
}
