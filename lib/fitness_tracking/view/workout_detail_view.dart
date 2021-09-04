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
    return BlocConsumer<WorkoutDetailViewBloc, WorkoutDetailViewState>(
      listener: (context, state) {
        if (state is WorkoutDetailViewDeleteSuccess) {
          BlocProvider.of<WorkoutsListBloc>(context).add(WorkoutsListItemRemoved(state.workout.info));
        } else if (state is WorkoutDetailViewSetAsActiveSuccess) {
          BlocProvider.of<WorkoutsListBloc>(context).add(WorkoutsListItemUpdated(state.workout.info));
        }
      },
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
                  buildWhen: (p, c) => p.workout.info.note != c.workout.info.note,
                  builder: (context, state) {
                    return Text(state.workout.info.title);
                  },
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: state.appBarLinearGradient,
                    borderRadius: state.appBarBorderRadius,
                  ),
                  child: FlexibleSpaceBar(
                    background: WorkoutInfoRow(
                      created: state.workout.info.mapCreatedToText,
                      daysPerWeek: state.workout.info.daysPerWeek.toStringAsFixed(0),
                      goal: mapWorkoutGoalToText(state.workout.info.goal),
                    ),
                  ),
                ),
                expandedHeight: 200,
                actions: [
                  PopupMenuButton<WorkoutsListCardOptions>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return WorkoutsListCardOptions.values.map((e) {
                        return PopupMenuItem(
                          child: Text(
                            mapWorkoutsListCardOptionsToString(e),
                          ),
                          value: e,
                        );
                      }).toList();
                    },
                    onSelected: (option) {
                      if (option == WorkoutsListCardOptions.delete) {
                        BlocProvider.of<WorkoutDetailViewBloc>(context).add(WorkoutDetailViewDeleteRequested());
                      } else if (option == WorkoutsListCardOptions.setAsActive) {
                        BlocProvider.of<WorkoutDetailViewBloc>(context).add(WorkoutDetailViewSetAsActiveRequested());
                      } else if (option == WorkoutsListCardOptions.edit) {
                        Navigator.of(context).push(AddWorkoutView.routeFromWorkoutDetailView(context, workout: state.workout));
                      }
                    },
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      if (state.workout.info.note != null) ...{
                        Text(
                          'Info',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(state.workout.info.note!),
                      },
                      ...state.workout.workoutDays!.workoutDays.map(
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
