import 'package:activity_repository/activity_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

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
              _ExcerciseNameInput(),
              _DurationInput(),
            ],
          );
        },
      ),
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
