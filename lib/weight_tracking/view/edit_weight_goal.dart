import 'package:fit_tip/utilities/app_config.dart';
import 'package:fit_tip/weight_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditWeightGoalView extends StatelessWidget {
  static const routeName = 'edit_weight_goal_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          _StartDateFormInput(),
          _StartWeightFormInput(),
          _TargetDateFormInput(),
          _TargetWeightFormInput(),
        ],
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
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Start date:'),
          trailing: Text(AppConfig.dateFormat(state.startDate.value)),
          onTap: () async {
            DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: state.startDate.value,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().subtract(Duration(days: 60)),
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
          trailing: Text(AppConfig.dateFormat(state.startDate.value)),
          onTap: () async {
            DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: state.startDate.value,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().subtract(Duration(days: 60)),
            );

            BlocProvider.of<EditWeightGoalFormBloc>(context).add(EditWeightGoalTargetDateChanged(value: dateTime));
          },
        );
      },
    );
  }
}
