import 'package:fit_tip/authentication/authentication.dart';
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
              create: (context) => WorkoutsListBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
              )..add(WorkoutsListLoadRequested()),
            ),
            BlocProvider(
              create: (context) => UserWorkoutsListBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
              ),
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
      body: AllWorkoutsListBuilder(),
      bottomNavigationBar: FitnessWorkoutsViewSelector(),
    );
  }
}
