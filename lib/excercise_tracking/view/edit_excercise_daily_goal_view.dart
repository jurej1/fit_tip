import 'package:activity_repository/activity_repository.dart';
import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class EditExcerciseDailyGoalView extends StatelessWidget {
  const EditExcerciseDailyGoalView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    final daySelectorBloc = BlocProvider.of<DaySelectorBloc>(context);
    final excerciseDailyGoalBloc = BlocProvider.of<ExcerciseDailyGoalBloc>(context);

    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => EditExcerciseDailyGoalBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                activityRepository: RepositoryProvider.of<ActivityRepository>(context),
                daySelectorBloc: daySelectorBloc,
                excerciseDailyGoalBloc: excerciseDailyGoalBloc,
              ),
            ),
            BlocProvider.value(value: excerciseDailyGoalBloc)
          ],
          child: EditExcerciseDailyGoalView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit excercise daily goal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              BlocProvider.of<EditExcerciseDailyGoalBloc>(context).add(EditExcerciseDailyGoalFormSubmited());
            },
          ),
        ],
      ),
      body: BlocConsumer<EditExcerciseDailyGoalBloc, EditExcerciseDailyGoalState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pop();
            BlocProvider.of<ExcerciseDailyGoalBloc>(context).add(ExcerciseDailyGoalUpdated(state.goal()));
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Oops something went wrong'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status.isSubmissionInProgress) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            physics: const ClampingScrollPhysics(),
            children: [
              const _MinutesPerDayInput(),
              const _CaloriesBurnedPerDayInput(),
              const _WorkoutsPerWeekInput(),
              const _MinutesPerWorkoutInput(),
            ],
          );
        },
      ),
    );
  }
}

class _CaloriesBurnedPerDayInput extends StatelessWidget {
  const _CaloriesBurnedPerDayInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditExcerciseDailyGoalBloc, EditExcerciseDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.caloriesBurnedPerDay.value,
          onChanged: (value) {
            BlocProvider.of<EditExcerciseDailyGoalBloc>(context).add(EditExcerciseDailyGoalCaloriesBurnedPerDayUpdated(value));
          },
          unit: 'cal',
          title: 'Calories burned (day):',
          keyboardType: TextInputType.number,
        );
      },
    );
  }
}

class _WorkoutsPerWeekInput extends StatelessWidget {
  const _WorkoutsPerWeekInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditExcerciseDailyGoalBloc, EditExcerciseDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.workoutsPerWeek.value,
          onChanged: (value) {
            BlocProvider.of<EditExcerciseDailyGoalBloc>(context).add(EditExcerciseDailyGoalWorkoutsPerWeekUpdated(value));
          },
          unit: 'x',
          title: 'Workouts per week',
          keyboardType: TextInputType.number,
        );
      },
    );
  }
}

class _MinutesPerWorkoutInput extends StatelessWidget {
  const _MinutesPerWorkoutInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditExcerciseDailyGoalBloc, EditExcerciseDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.minutesPerWorkout.value,
          onChanged: (value) {
            BlocProvider.of<EditExcerciseDailyGoalBloc>(context).add(EditExcerciseDailyGoalMinutesPerWorkoutUpdated(value));
          },
          unit: 'min',
          title: 'Avg min per workout',
          keyboardType: TextInputType.number,
        );
      },
    );
  }
}

class _MinutesPerDayInput extends StatelessWidget {
  const _MinutesPerDayInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditExcerciseDailyGoalBloc, EditExcerciseDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.minutesPerDay.value,
          onChanged: (value) {
            BlocProvider.of<EditExcerciseDailyGoalBloc>(context).add(EditExcerciseDailyGoalMinutesPerDayUpdated(value));
          },
          unit: 'min',
          title: 'Min per day',
          keyboardType: TextInputType.number,
        );
      },
    );
  }
}
