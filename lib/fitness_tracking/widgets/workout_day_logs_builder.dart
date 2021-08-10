import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutDayLogsBuilder extends StatelessWidget {
  const WorkoutDayLogsBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutDayLogsBloc, WorkoutDayLogsState>(
      builder: (context, state) {
        if (state is WorkoutDayLogsLoading) {
          return Column(
            children: [
              LinearProgressIndicator(),
            ],
          );
        } else if (state is WorkoutDayLogsLoadSuccess) {
          if (state.logs.isEmpty) {
            return Center(
              child: Text('You do not have any workout logs'),
            );
          }

          return ListView.builder(
            itemCount: state.logs.length,
            itemBuilder: (context, index) {
              final item = state.logs[index];
              return ListTile(
                title: Text(item.created.toIso8601String()),
              );
            },
          );
        } else if (state is WorkoutDayLogsFailure) {
          return Center(
            child: Text('failure'),
          );
        }

        return Container();
      },
    );
  }
}
