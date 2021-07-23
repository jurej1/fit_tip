import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FitnessTrackingView extends StatelessWidget {
  const FitnessTrackingView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => FitnessTrackingViewCubit(),
            ),
            BlocProvider(
              create: (context) => WorkoutsListBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
              )..add(WorkoutsListLoadRequested()),
            ),
            BlocProvider(
              create: (context) => ActiveWorkoutBloc(
                workoutsListBloc: BlocProvider.of<WorkoutsListBloc>(context),
              ),
            ),
          ],
          child: FitnessTrackingView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessTrackingViewCubit, FitnessTrackingWorkoutPage>(
      builder: (context, page) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Fitness tracking'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(AddWorkoutView.route(context));
                },
              ),
            ],
          ),
          body: _body(page),
          bottomNavigationBar: FitnessTrackingViewSelector(),
        );
      },
    );
  }

  Widget _body(FitnessTrackingWorkoutPage page) {
    if (page == FitnessTrackingWorkoutPage.active) {
      return ActiveWorkoutBuilder.builder();
    }
    if (page == FitnessTrackingWorkoutPage.all) {
      return WorkoutsListBuilder();
    }

    return Container();
  }
}
