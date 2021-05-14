import 'package:fit_tip/utilities/app_config.dart';
import 'package:fit_tip/weight_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:weight_repository/weight_repository.dart';

class EditWeightGoalView extends StatelessWidget {
  static const routeName = 'edit_weight_goal_view';

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditWeightGoalFormBloc, EditWeightGoalFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<WeightGoalBloc>(context).add(WeightGoalUpdated(state.weightGoal));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            _SubmitButton(),
          ],
        ),
        body: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            _StartDateFormInput(),
            _StartWeightFormInput(),
            _TargetDateFormInput(),
            _TargetWeightFormInput(),
            _WeeklyGoalSelector(),
          ],
        ),
      ),
    );
  }
}

class _TargetWeightFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditWeightGoalFormBloc, EditWeightGoalFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.targetWeight.value,
          autocorrect: false,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Target Weight (kg)',
            errorText: state.targetWeight.invalid ? 'Invalid input' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<EditWeightGoalFormBloc>(context).add(EditWeightGoalTargetWeightChanged(value: value));
          },
        );
      },
    );
  }
}

class _StartWeightFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditWeightGoalFormBloc, EditWeightGoalFormState>(
      builder: (context, state) {
        return TextFormField(
          autocorrect: false,
          initialValue: state.targetWeight.value,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Start Weight (kg)',
            errorText: state.startWeight.invalid ? 'Invalid input' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<EditWeightGoalFormBloc>(context).add(EditWeightGoalStartWeigthChanged(value: value));
          },
        );
      },
    );
  }
}

class _StartDateFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditWeightGoalFormBloc, EditWeightGoalFormState>(
      builder: (_, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Start date:'),
          subtitle: state.startDate.invalid ? Text('Invalid input') : null,
          trailing: Text(AppConfig.dateFormat(state.startDate.value)),
          onTap: () async {
            DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: state.startDate.value,
              firstDate: DateTime.now().subtract(Duration(days: 365)),
              lastDate: DateTime.now(),
            );

            BlocProvider.of<EditWeightGoalFormBloc>(context).add(EditWeightGoalStartDateChanged(value: dateTime));
          },
        );
      },
    );
  }
}

class _TargetDateFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditWeightGoalFormBloc, EditWeightGoalFormState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Target date:'),
          subtitle: state.targetDate.invalid ? Text('Invalid input') : null,
          trailing: Text(AppConfig.dateFormat(state.targetDate.value)),
          onTap: () async {
            DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: state.targetDate.value,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );

            BlocProvider.of<EditWeightGoalFormBloc>(context).add(EditWeightGoalTargetDateChanged(value: dateTime));
          },
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditWeightGoalFormBloc, EditWeightGoalFormState>(
      builder: (context, state) {
        return TextButton(
          child: Text('Submit'),
          onPressed: () {
            BlocProvider.of<EditWeightGoalFormBloc>(context).add(EditWeightGoalFormSubmit());
          },
        );
      },
    );
  }
}

class _WeeklyGoalSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditWeightGoalFormBloc, EditWeightGoalFormState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Weekly goal'),
          trailing: DropdownButton<WeeklyGoal>(
            value: state.weeklyGoal,
            items: WeeklyGoal.values
                .map(
                  (goal) => DropdownMenuItem(
                    child: Text(mapWeeklyGoalToString(goal)),
                    value: goal,
                  ),
                )
                .toList(),
            onChanged: (goal) {
              BlocProvider.of<EditWeightGoalFormBloc>(context).add(EditWeightGoalWeeklyGoalChanged(goal));
            },
          ),
        );
      },
    );
  }
}
