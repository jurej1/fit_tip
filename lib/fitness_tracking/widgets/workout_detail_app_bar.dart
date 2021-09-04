import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class WorkoutDetailAppBar extends StatelessWidget {
  const WorkoutDetailAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutDetailViewBloc, WorkoutDetailViewState>(
      builder: (context, state) {
        return SliverAppBar(
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
                  // BlocProvider.of<WorkoutDetailViewBloc>(context).add(WorkoutDetailViewDeleteRequested());
                } else if (option == WorkoutsListCardOptions.setAsActive) {
                  // BlocProvider.of<WorkoutDetailViewBloc>(context).add(WorkoutDetailViewSetAsActiveRequested());
                } else if (option == WorkoutsListCardOptions.edit) {
                  Navigator.of(context).push(AddWorkoutView.routeFromWorkoutDetailView(context, workout: state.workout));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
