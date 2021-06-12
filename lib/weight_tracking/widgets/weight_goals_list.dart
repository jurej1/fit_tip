import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weight_repository/weight_repository.dart';

class WeightGoalsList extends StatelessWidget {
  final double height = 8;

  final WeightGoal goal;

  const WeightGoalsList({Key? key, required this.goal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: Text('Goals'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(EditWeightGoalView.route(context));
              },
            ),
          ),
          SizedBox(height: height),
          GoalRow(
            text: 'Begin date',
            value: goal.beginDate != null ? DateFormat('dd.MM.yyyy').format(goal.beginDate!) : '-',
          ),
          SizedBox(height: height),
          GoalRow(
            text: 'Begin weight',
            value: goal.beginWeight != null ? '${goal.beginWeight?.toString()}kg' : '-',
          ),
          SizedBox(height: height),
          GoalRow(
            text: 'Target date',
            value: goal.targetDate != null ? DateFormat('dd.MM.yyyy').format(goal.beginDate!) : '',
          ),
          SizedBox(height: height),
          GoalRow(
            text: 'Target weight',
            value: goal.targetWeight != null ? '${goal.targetWeight?.toString()}kg' : '-',
          ),
          SizedBox(height: height),
          GoalRow(
            text: 'Weekly goal',
            value: mapWeeklyGoalToString(goal.weeklyGoal),
          ),
        ],
      ),
    );
  }
}
