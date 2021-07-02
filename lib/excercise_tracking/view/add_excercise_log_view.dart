import 'package:activity_repository/activity_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/widgets/widgets.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class AddExcerciseLogView extends StatelessWidget {
  const AddExcerciseLogView({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final excerciseDailyListBloc = BlocProvider.of<ExcerciseDailyListBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddExcerciseLogBloc(
                activityRepository: RepositoryProvider.of<ActivityRepository>(context),
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              ),
            ),
            BlocProvider.value(
              value: excerciseDailyListBloc,
            ),
          ],
          child: AddExcerciseLogView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Excercise Log'),
      ),
      body: BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
        builder: (context, state) {
          if (state.status.isSubmissionInProgress) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          return ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              _wrappedPadding(const _ExcerciseNameInput()),
              const _DurationInput(),
              _wrappedPadding(const IntensityInput()),
              _wrappedPadding(const _CaloriesInput()),
              _wrappedPadding(const _TimeInput()),
              _wrappedPadding(const _DateInput()),
            ],
          );
        },
      ),
    );
  }

  Widget _wrappedPadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }
}

class _DurationInput extends StatelessWidget {
  const _DurationInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration:'),
            const SizedBox(height: 10),
            DurationSelector(
              duration: state.duration.value,
            ),
          ],
        );
      },
    );
  }
}

class _ExcerciseNameInput extends StatelessWidget {
  const _ExcerciseNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.name.value,
          decoration: InputDecoration(
            errorText: state.name.invalid ? 'Invalid' : null,
            labelText: 'Excercise name',
          ),
          onChanged: (val) => BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogNameUpdated(val)),
        );
      },
    );
  }
}

class _CaloriesInput extends StatelessWidget {
  const _CaloriesInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.calories.value,
          onChanged: (value) {
            BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogCaloriesUpdated(value));
          },
          unit: 'cal',
          title: 'Calories',
        );
      },
    );
  }
}

class _TimeInput extends StatelessWidget {
  const _TimeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Start time: '),
          trailing: Text(
            state.time.value.format(context),
          ),
          onTap: () async {
            TimeOfDay? time = await showTimePicker(context: context, initialTime: state.time.value);
            BlocProvider.of<AddExcerciseLogBloc>(context).add(AddExcerciseLogTimeUpdated(time));
          },
        );
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  const _DateInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
      builder: (context, state) {
        return ListTile(
          title: Text('Date: '),
          trailing: Text(
            DateFormat('dd.MMMM.yyyy').format(state.date.value),
          ),
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: state.date.value,
              firstDate: BlocProvider.of<AuthenticationBloc>(context).state.user!.dateJoined!,
              lastDate: DateTime.now(),
            );
          },
        );
      },
    );
  }
}
