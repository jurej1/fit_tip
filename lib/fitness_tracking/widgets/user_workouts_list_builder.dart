import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class UserWorkoutsListBuilder extends StatelessWidget {
  const UserWorkoutsListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserWorkoutsListBloc, WorkoutInfosBaseState>(
      builder: (context, state) {
        if (state is WorkoutInfosLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WorkoutInfosLoadSuccess) {
          return WorkoutInfosList(
            hasReachedMax: state.hasReachedMax,
            workouts: state.infos,
            onBottom: () {
              BlocProvider.of<UserWorkoutsListBloc>(context).add(WorkoutInfosLoadMoreRequested());
            },
          );
        } else if (state is WorkoutInfosFail) {
          return Center(
            child: Text('Oops something went wrong'),
          );
        }

        return Container();
      },
    );
  }
}
