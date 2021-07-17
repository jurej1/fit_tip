import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddWorkoutView extends StatelessWidget {
  const AddWorkoutView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
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
            )
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
        ));
  }
}
