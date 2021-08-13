import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddWorkoutView {
  static List<dynamic> _baseProviders(context, Workout? workout) => [
        BlocProvider(
          create: (_) => AddWorkoutViewCubit(),
        ),
        BlocProvider(
          create: (_) => AddWorkoutFormBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
            workout: workout,
          ),
        ),
        BlocProvider(
          create: (context) => AddWorkoutFloatingActionButtonCubit(
            addWorkoutViewCubit: BlocProvider.of<AddWorkoutViewCubit>(context),
          ),
        )
      ];

  static MaterialPageRoute route(BuildContext context, {Workout? workout}) {
    final workoutsListBloc = BlocProvider.of<WorkoutsListBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            ..._baseProviders(context, workout),
            BlocProvider.value(value: workoutsListBloc),
          ],
          child: _FormBuilder(),
        );
      },
    );
  }

  static MaterialPageRoute routeFromWorkoutDetailView(BuildContext context, {required Workout workout}) {
    final workoutsListBloc = BlocProvider.of<WorkoutsListBloc>(context);
    final workoutDetailViewBloc = BlocProvider.of<WorkoutDetailViewBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            ..._baseProviders(context, workout),
            BlocProvider.value(value: workoutsListBloc),
            BlocProvider.value(value: workoutDetailViewBloc),
          ],
          child: const _FormFromDetailPageBuilder(),
        );
      },
    );
  }
}

class _FormBuilder extends StatelessWidget {
  const _FormBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddWorkoutFormBloc, AddWorkoutFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess && state.formMode == FormMode.add) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Workout added')));
          BlocProvider.of<WorkoutsListBloc>(context).add(WorkoutsListItemAdded(state.workout));
          Navigator.of(context).pop();
        }

        if (state.status.isSubmissionSuccess && state.formMode == FormMode.edit) {
          BlocProvider.of<WorkoutsListBloc>(context).add(WorkoutsListItemUpdated(state.workout));
          Navigator.of(context).pop();
        }
      },
      child: const _ViewBase(),
    );
  }
}

class _FormFromDetailPageBuilder extends StatelessWidget {
  const _FormFromDetailPageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddWorkoutFormBloc, AddWorkoutFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess && state.formMode == FormMode.edit) {
          BlocProvider.of<WorkoutsListBloc>(context).add(WorkoutsListItemUpdated(state.workout));
          BlocProvider.of<WorkoutDetailViewBloc>(context).add(WorkoutDetailViewWorkoutUpdated(state.workout));
          Navigator.of(context).pop();
        }
      },
      child: const _ViewBase(),
    );
  }
}

class _ViewBase extends StatelessWidget {
  const _ViewBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddWorkoutViewAppBar(),
      body: BlocBuilder<AddWorkoutFormBloc, AddWorkoutFormState>(
        builder: (context, state) {
          if (state.status.isSubmissionInProgress) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              const AddWorkoutFormSelectedViewDisplayer(),
              Expanded(
                child: PageView(
                  children: [
                    const WorkoutForm(),
                    const WorkoutDaysForm(),
                  ],
                  onPageChanged: (index) {
                    FocusScope.of(context).unfocus();
                    BlocProvider.of<AddWorkoutViewCubit>(context).viewIndexUpdated(index);
                  },
                  physics: const BouncingScrollPhysics(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
