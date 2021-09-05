import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                timerBloc: BlocProvider.of<TimerBloc>(context),
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
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: _AppBarTextDisplayer(),
          actions: [
            BlocBuilder<RunningWorkoutDayBloc, RunningWorkoutDayState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.log.excercises?.length != 0,
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
          buildWhen: (p, c) => p != c,
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
                              'Excercises ${state.log.excercises?.length}',
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

                      final item = state.log.excercises![index - 1];
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

class _SelectedPageDisplayer extends StatefulWidget {
  const _SelectedPageDisplayer({Key? key}) : super(key: key);

  @override
  __SelectedPageDisplayerState createState() => __SelectedPageDisplayerState();
}

class __SelectedPageDisplayerState extends State<_SelectedPageDisplayer> {
  late final ScrollController _scrollController;
  final double dotSize = 10;
  final double spaceWidth = 8;
  final double boxWidt = 50;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RunningWorkoutDayBloc, RunningWorkoutDayState>(
      listener: (context, state) {
        _scrollController.animateTo(
          _mapPageIndexToOffset(state.pageViewIndex),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );
      },
      builder: (context, state) {
        return SizedBox(
          width: boxWidt,
          child: ListView.separated(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: boxWidt * 0.5),
            scrollDirection: Axis.horizontal,
            itemCount: state.pageViewLength,
            itemBuilder: (context, index) {
              return Container(
                height: dotSize,
                width: dotSize,
                decoration: BoxDecoration(
                  color: state.pageViewIndex == index ? Colors.white : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: spaceWidth);
            },
          ),
        );
      },
    );
  }

  double _mapPageIndexToOffset(int index) {
    return (index * dotSize) + ((index - 1) * spaceWidth) + boxWidt * 0.25;
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
        final item = state.log.excercises![index];
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
    return BlocBuilder<TimerBloc, TimerState>(
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
