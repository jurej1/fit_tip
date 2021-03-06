import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutDayLogsBuilder extends StatelessWidget {
  const WorkoutDayLogsBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<WorkoutDayLogsBloc, WorkoutDayLogsState>(
      builder: (context, state) {
        if (state is WorkoutDayLogsLoading) {
          return Column(
            children: [
              const LinearProgressIndicator(),
            ],
          );
        } else if (state is WorkoutDayLogsLoadSuccess) {
          if (state.logs.isEmpty) {
            return Center(
              child: const Text('You do not have any workout logs'),
            );
          }

          return ListView.separated(
            itemCount: state.logs.length,
            itemBuilder: (context, index) {
              final item = state.logs[index];
              return WorkoutDayLogCard(item: item);
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 5,
                color: Colors.blue.shade100,
                width: size.width,
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
