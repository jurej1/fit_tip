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
    return Scaffold(
      bottomNavigationBar: FitnessTrackingViewSelector(),
    );
  }
}
