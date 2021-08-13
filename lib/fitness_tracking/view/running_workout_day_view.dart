import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../fitness_tracking.dart';

class RunningWorkoutDayView extends StatelessWidget {
  const RunningWorkoutDayView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, WorkoutDay workoutDay, DateTime date) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TimerBloc(),
            ),
            BlocProvider(
              create: (context) => RunningWorkoutDayBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
                workoutDay: workoutDay,
                date: date,
              ),
            ),
            BlocProvider.value(
              value: BlocProvider.of<WorkoutDayLogsBloc>(context),
            )
          ],
          child: RunningWorkoutDayView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RunningWorkoutDayBloc, RunningWorkoutDayState>(
      listener: (context, state) {
        if (state is RunningWorkoutDayLoadSuccess) {
          BlocProvider.of<WorkoutDayLogsBloc>(context).add(WorkoutDayLogsLogAdded(state.log));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: _AppBarTextDisplayer(),
          actions: [
            BlocBuilder<RunningWorkoutDayBloc, RunningWorkoutDayState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.log.excercises.length != 0,
                  child: Row(
                    children: [
                      const _SelectedPageDisplayer(),
                      const SizedBox(width: 20),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<RunningWorkoutDayBloc, RunningWorkoutDayState>(
          listener: (contex, state) {
            if (state.pageViewIndex == 1) {
              BlocProvider.of<TimerBloc>(context).add(TimerStart());
            }
          },
          builder: (context, state) {
            if (state is RunningWorkoutDayLoading) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: (state.pageViewIndex == 0 || state.pageViewIndex == state.pageViewLength - 1) ? 0 : 30,
                  alignment: Alignment.center,
                  child: _TimerBuilder(),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: state.pageViewLength,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListView(
                          children: [
                            Text(
                              'Excercises ${state.log.excercises.length}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      }
                      if (index == state.pageViewLength - 1) {
                        return Center(
                          child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () {
                              BlocProvider.of<TimerBloc>(context).add(TimerStop());
                              BlocProvider.of<RunningWorkoutDayBloc>(context).add(RunningWorkoutDayWorkoutExcerciseSubmit());
                            },
                          ),
                        );
                      }

                      final item = state.log.excercises[index - 1];
                      return ExcercisePageCard.provider(item);
                    },
                    onPageChanged: (index) {
                      BlocProvider.of<RunningWorkoutDayBloc>(context).add(RunningWorkoutDayPageIndexUpdated(index));
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SelectedPageDisplayer extends HookWidget {
  const _SelectedPageDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(
      initialValue: BlocProvider.of<RunningWorkoutDayBloc>(context).state.pageViewIndex.toDouble(),
      upperBound: BlocProvider.of<RunningWorkoutDayBloc>(context).state.pageViewLength.toDouble(),
      duration: const Duration(milliseconds: 300),
    );
    return BlocConsumer<RunningWorkoutDayBloc, RunningWorkoutDayState>(
      listener: (context, state) {
        _controller.animateTo(state.pageViewIndex.toDouble());
      },
      builder: (context, state) {
        return SelectedViewDisplayer(
          dotSize: 10,
          length: state.pageViewLength,
          controller: _controller,
          width: 40,
          selectedColor: Colors.blue,
        );
      },
    );
  }
}

class _AppBarTextDisplayer extends StatelessWidget {
  const _AppBarTextDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunningWorkoutDayBloc, RunningWorkoutDayState>(
      builder: (context, state) {
        if (state.pageViewIndex == 0) return Text('Overview');
        if (state.pageViewIndex == state.pageViewLength - 1) return Text('Submit');

        final int index = state.pageViewIndex - 1;
        final item = state.log.excercises[index];
        return Text('${index + 1}. ${item.name}');
      },
    );
  }
}

class _TimerBuilder extends StatelessWidget {
  _TimerBuilder({Key? key}) : super(key: key);

  final _textStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 19,
  );
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerBloc, TimerState>(
      listener: (context, state) {
        BlocProvider.of<RunningWorkoutDayBloc>(context).add(RunningWorkoutDayWorkoutDurationUpdated(state.duration));
      },
      builder: (context, state) {
        if (state.hours != 0) {
          return Text(
            '${state.hours}:${state.minutes}:${state.seconds}',
            style: _textStyle,
          );
        }
        return Text(
          '${state.minutes}:${state.seconds}',
          style: _textStyle,
        );
      },
    );
  }
}
