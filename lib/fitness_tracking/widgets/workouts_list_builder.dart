import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutsListBuilder extends StatelessWidget {
  const WorkoutsListBuilder({Key? key}) : super(key: key);

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
          return ListView.separated(
            itemCount: state.workouts.length,
            itemBuilder: (context, index) {
              final item = state.workouts[index];
              return WorkoutsListCard();
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 5);
            },
          );
        }

        return Container();
      },
    );
  }
}
