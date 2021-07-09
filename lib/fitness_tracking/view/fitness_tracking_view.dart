import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
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
      return Container(
        child: Center(
          child: Text('Active'),
        ),
      );
    }
    if (page == FitnessTrackingWorkoutPage.all) {
      return Container(
        child: Center(
          child: Text('All'),
        ),
      );
    }

    return Container();
  }
}
