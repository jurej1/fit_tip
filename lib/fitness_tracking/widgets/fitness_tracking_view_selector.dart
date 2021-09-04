import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FitnessTrackingViewSelector extends StatelessWidget {
  const FitnessTrackingViewSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessTrackingViewCubit, FitnessTrackingWorkoutPage>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: FitnessTrackingWorkoutPage.values.indexOf(state),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.pin),
              label: 'Active',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              label: 'Active History',
            ),
          ],
          onTap: (index) {
            BlocProvider.of<FitnessTrackingViewCubit>(context).viewUpdated(index);
          },
        );
      },
    );
  }
}
