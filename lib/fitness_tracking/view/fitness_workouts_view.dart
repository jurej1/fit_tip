import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/widgets/user_workouts_list_builder.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class FitnessWorkoutsView extends StatelessWidget {
  const FitnessWorkoutsView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => FitnessWorkoutsViewSelectorCubit(),
            ),
            BlocProvider(
              create: (context) => WorkoutInfosListBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
              )..add(WorkoutInfosLoadRequested()),
            ),
            BlocProvider(
              create: (context) => UserWorkoutsListBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
              )..add(WorkoutInfosLoadRequested()),
            ),
          ],
          child: FitnessWorkoutsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Workouts View'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(AddWorkoutView.route(context));
            },
          )
        ],
      ),
      body: BlocBuilder<FitnessWorkoutsViewSelectorCubit, FitnessWorkoutsViewSelectorState>(
        builder: (context, state) {
          if (state.isAll) return AllWorkoutsListBuilder();
          if (state.isUser) return UserWorkoutsListBuilder();
          return Container();
        },
      ),
      bottomNavigationBar: FitnessWorkoutsViewSelector(),
    );
  }
}
