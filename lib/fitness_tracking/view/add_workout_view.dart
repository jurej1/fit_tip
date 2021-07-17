import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddWorkoutView extends StatelessWidget {
  const AddWorkoutView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    final workoutsListBloc = BlocProvider.of<WorkoutsListBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AddWorkoutViewCubit(),
            ),
            BlocProvider(
              create: (_) => AddWorkoutFormBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => AddWorkoutFloatingActionButtonCubit(
                addWorkoutViewCubit: BlocProvider.of<AddWorkoutViewCubit>(context),
              ),
            ),
            BlocProvider.value(value: workoutsListBloc),
          ],
          child: AddWorkoutView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddWorkoutViewAppBar(),
      body: BlocConsumer<AddWorkoutFormBloc, AddWorkoutFormState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Workout added')));
            BlocProvider.of<WorkoutsListBloc>(context).add(WorkoutsListItemAdded(state.workout));
            Navigator.of(context).pop();
          }
        },
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
