import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../fitness_tracking.dart';

class WorkoutForm extends StatelessWidget {
  const WorkoutForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _WorkoutGoalInput(),
        const _WorkoutTypeInput(),
        const _WorkoutDurationInput(),
        const _WorkoutDaysPerWeekInput(),
        const _WorkoutTimePerWorkoutInput(),
        const _WorkoutStartDateInput(),
      ],
    );
  }
}

class _WorkoutGoalInput extends StatelessWidget {
  const _WorkoutGoalInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutFormBloc, AddWorkoutFormState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Main goal:'),
            DropdownButton(
              value: state.goal.value,
              items: WorkoutGoal.values
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(describeEnum(e)),
                      value: e,
                    ),
                  )
                  .toList(),
              onChanged: (WorkoutGoal? goal) {
                BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormGoalUpdated(goal));
              },
            ),
          ],
        );
      },
    );
  }
}

class _WorkoutTypeInput extends StatelessWidget {
  const _WorkoutTypeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutFormBloc, AddWorkoutFormState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Type: '),
            DropdownButton(
              value: state.type.value,
              items: WorkoutType.values
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        describeEnum(e),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (WorkoutType? value) {
                BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormTypeUpdated(value));
              },
            ),
          ],
        );
      },
    );
  }
}

class _WorkoutDurationInput extends StatelessWidget {
  const _WorkoutDurationInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutFormBloc, AddWorkoutFormState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.duration.value,
          onChanged: (val) {
            BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormDurationUpdated(val));
          },
          unit: 'min',
          title: 'Avg workout duration',
          keyboardType: TextInputType.number,
        );
      },
    );
  }
}

class _WorkoutDaysPerWeekInput extends StatelessWidget {
  const _WorkoutDaysPerWeekInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutFormBloc, AddWorkoutFormState>(
      builder: (context, state) {
        return RowInputField(
            initialValue: state.daysPerWeek.value,
            onChanged: (value) {
              BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormDaysPerWeekUpdated(value));
            },
            unit: 'x',
            title: 'Days per week',
            keyboardType: TextInputType.number);
      },
    );
  }
}

class _WorkoutTimePerWorkoutInput extends StatelessWidget {
  const _WorkoutTimePerWorkoutInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutFormBloc, AddWorkoutFormState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.timePerWorkout.value,
          onChanged: (val) {
            BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormTimePerWorkoutUpdated(val));
          },
          unit: 'min',
          title: 'Time per workout',
          keyboardType: TextInputType.number,
        );
      },
    );
  }
}

class _WorkoutStartDateInput extends StatelessWidget {
  const _WorkoutStartDateInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutFormBloc, AddWorkoutFormState>(
      builder: (context, state) {
        return ListTile(
          title: Text(
            'Start date:',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          trailing: Text(DateFormat('dd.MMMM.yyy').format(state.startDate.value)),
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: state.startDate.value,
              firstDate: BlocProvider.of<AuthenticationBloc>(context).state.user!.dateJoined!,
              lastDate: DateTime.now(),
            );

            BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormStartDateUpdated(date));
          },
        );
      },
    );
  }
}
