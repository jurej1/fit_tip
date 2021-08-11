import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutDayLogCard extends StatelessWidget {
  const WorkoutDayLogCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final WorkoutDayLog item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade300,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(WorkoutDayLogDetailView.route(item));
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout on ${DateFormat('EEE, MMM d ' 'yy').format(item.created)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Wrap(
                children: item.musclesTargeted
                        ?.map(
                          (e) => Chip(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            label: Text(mapMuscleGroupToString(e)),
                            padding: const EdgeInsets.all(2),
                            backgroundColor: Colors.blue.shade100,
                          ),
                        )
                        .toList() ??
                    [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
