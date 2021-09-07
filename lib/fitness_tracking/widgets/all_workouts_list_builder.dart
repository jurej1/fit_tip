import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllWorkoutsListBuilder extends StatelessWidget {
  const AllWorkoutsListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutInfosListBloc, WorkoutInfosBaseState>(
      builder: (context, state) {
        if (state is WorkoutInfosLoading) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is WorkoutInfosFail) {
          return Center(
            child: Text('Sorry there was an error'),
          );
        } else if (state is WorkoutInfosLoadSuccess) {
          return WorkoutInfosList(
            hasReachedMax: state.hasReachedMax,
            workouts: state.infos,
            onBottom: () {
              BlocProvider.of<WorkoutInfosListBloc>(context).add(WorkoutInfosLoadMoreRequested());
            },
          );
        }

        return Container();
      },
    );
  }
}
