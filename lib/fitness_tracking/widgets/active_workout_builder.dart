import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
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
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            activeWorkoutBloc: BlocProvider.of<ActiveWorkoutBloc>(context),
            tableCalendarBloc: BlocProvider.of<TableCalendarBloc>(context),
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
              Text('Fitness tracking'),
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You do not have any workouts today')));
                  } else {
                    Navigator.of(context).push(WorkoutActiveView.route(state.workoutDay!));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Loading... try again in a second')));
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
          return PageView(
            physics: const ClampingScrollPhysics(),
            children: [
              const Page1(),
              const Page2(),
            ],
            onPageChanged: (index) {
              BlocProvider.of<ActiveWorkoutViewSelectorCubit>(context).viewUpdatedIndex(index);
            },
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

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, state) {
        if (state is ActiveWorkoutLoadSuccess) {
          return ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            children: [
              WorkoutInfoRow(
                created: state.workout.mapCreatedToText,
                daysPerWeek: state.workout.daysPerWeek.toStringAsFixed(0),
                goal: mapWorkoutGoalToText(state.workout.goal),
              ),
              if (state.workout.note != null) ...{
                Text(
                  'Info',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(state.workout.note!),
                const SizedBox(height: 10),
              },
              ...state.workout.workouts
                  .map(
                    (e) => Column(
                      children: [
                        WorkoutDetailItem(workout: e),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                  .toList(),
            ],
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
        width: 30,
        dotSize: 10,
        length: ActiveWorkoutView.values.length,
        controller: _controller,
        selectedColor: Colors.white,
      ),
    );
  }
}
