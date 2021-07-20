import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';

import '../fitness_tracking.dart';

class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, {required Workout workout}) {
    final workoutsListBloc = BlocProvider.of<WorkoutsListBloc>(context);

    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => WorkoutDetailViewBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
                workout: workout,
              ),
            ),
            BlocProvider.value(value: workoutsListBloc),
          ],
          child: WorkoutDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutDetailViewBloc, WorkoutDetailViewState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverAppBar(
                shape: RoundedRectangleBorder(borderRadius: state.appBarBorderRadius),
                centerTitle: true,
                backgroundColor: Colors.green,
                title: BlocBuilder<WorkoutDetailViewBloc, WorkoutDetailViewState>(
                  buildWhen: (p, c) => p.workout.note != c.workout.note,
                  builder: (context, state) {
                    return Text(state.workout.title);
                  },
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: state.appBarLinearGradient,
                    borderRadius: state.appBarBorderRadius,
                  ),
                  child: FlexibleSpaceBar(
                    background: WorkoutInfoRow(),
                  ),
                ),
                expandedHeight: 200,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      if (state.workout.note != null) ...{
                        Text('Info'),
                        Text(state.workout.note!),
                      },
                      ...state.workout.workouts.map(
                        (e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: WorkoutDetailItem(workout: e),
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WorkoutDetailItem extends StatelessWidget {
  const WorkoutDetailItem({
    Key? key,
    required this.workout,
  }) : super(key: key);

  final WorkoutDay workout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(workout.mapDayToText),
        if (workout.musclesTargeted != null)
          ...workout.musclesTargeted!
              .map(
                (e) => Chip(
                  label: Text(mapMuscleGroupToString(e)),
                ),
              )
              .toList(),
        Row(
          children: [
            WorkoutExcerciseRowData(
              text: 'Name',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            WorkoutExcerciseRowData(
              text: 'Sets',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            WorkoutExcerciseRowData(
              text: 'Reps',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        ...workout.excercises.map((e) {
          return Row(
            children: [
              WorkoutExcerciseRowData(text: e.name),
              WorkoutExcerciseRowData(text: e.setsString),
              WorkoutExcerciseRowData(text: e.repsString),
            ],
          );
        }).toList(),
      ],
    );
  }
}
