import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
              LinearProgressIndicator(),
            ],
          );
        } else if (state is WorkoutDayLogsLoadSuccess) {
          if (state.logs.isEmpty) {
            return Center(
              child: Text('You do not have any workout logs'),
            );
          }

          return ListView.separated(
            itemCount: state.logs.length,
            itemBuilder: (context, index) {
              final item = state.logs[index];

              return Material(
                color: Colors.grey.shade300,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workout on ${DateFormat('EEE, MMM d ' 'yy').format(item.created)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        children: item.musclesTargeted
                                ?.map(
                                  (e) => Chip(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    label: Text(mapMuscleGroupToString(e)),
                                    padding: EdgeInsets.all(2),
                                    backgroundColor: Colors.blue.shade100,
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                    ],
                  ),
                ),
              );
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
