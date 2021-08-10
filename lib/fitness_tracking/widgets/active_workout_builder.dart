import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/widgets/widgets.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fitness tracking'),
              _AppBarPageDisplayer(),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(AddWorkoutView.route(context));
              },
            ),
          ],
        ),
        body: _bodyBuilder(),
        bottomNavigationBar: FitnessTrackingViewSelector(),
        floatingActionButton: BlocBuilder<FocusedWorkoutDayBloc, FocusedWorkoutDayState>(
          builder: (context, state) {
            return FloatingActionButton.extended(
              onPressed: () {
                if (state is FocusedWorkoutDayLoadSuccess) {
                  if (state.workoutDay == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('You do not have any workouts today')));
                  } else {
                    Navigator.of(context).push(
                      RunningWorkoutDayView.route(
                        state.workoutDay!,
                        state.date,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Loading... try again in a second')));
                }
              },
              label: Text('Start Workout'),
            );
          },
        ),
      ),
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
          return BlocListener<ActiveWorkoutViewSelectorCubit, ActiveWorkoutView>(
            listener: (context, state) {
              if (state == ActiveWorkoutView.workoutLogs) {
                BlocProvider.of<WorkoutDayLogsBloc>(context).add(WorkoutDayLogsLoadRequested());
              }
            },
            child: PageView(
              physics: const ClampingScrollPhysics(),
              children: [
                const ActiveWorkoutOverviewBuilder(),
                const Page2(),
                const WorkoutDayLogsBuilder(),
              ],
              onPageChanged: (index) {
                BlocProvider.of<ActiveWorkoutViewSelectorCubit>(context).viewUpdatedIndex(index);
              },
            ),
          );
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

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, state) {
        if (state is ActiveWorkoutLoadSuccess) {
          return Container(
            child: ListView(
              children: [
                TableCalendarBuilder(),
                const SizedBox(height: 10),
                FocusedWorkoutDayBuilder(),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

class _AppBarPageDisplayer extends HookWidget {
  const _AppBarPageDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: ActiveWorkoutView.values.length.toDouble(),
    );
    return BlocListener<ActiveWorkoutViewSelectorCubit, ActiveWorkoutView>(
      listener: (context, state) {
        _controller.animateTo(ActiveWorkoutView.values.indexOf(state).toDouble());
      },
      child: SelectedViewDisplayer(
        unselectedColor: Colors.grey,
        width: 40,
        dotSize: 10,
        length: ActiveWorkoutView.values.length,
        controller: _controller,
        selectedColor: Colors.white,
      ),
    );
  }
}
