import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllWorkoutsListBuilder extends StatelessWidget {
  const AllWorkoutsListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutsListBloc, WorkoutsListState>(
      builder: (context, state) {
        if (state is WorkoutsListLoading) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is WorkoutsListFail) {
          return Center(
            child: Text('Sorry there was an error'),
          );
        } else if (state is WorkoutsListLoadSuccess) {
          return WorkoutsList(
            hasReachedMax: state.hasReachedMax,
            workouts: state.workoutInfos,
            onBottom: () {
              BlocProvider.of<WorkoutsListBloc>(context).add(WorkoutsListLoadMoreRequested());
            },
          );
        }

        return Container();
      },
    );
  }
}
