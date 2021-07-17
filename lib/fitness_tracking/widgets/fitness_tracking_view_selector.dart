import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FitnessTrackingViewSelector extends StatelessWidget {
  const FitnessTrackingViewSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FitnessTrackingViewCubit, FitnessTrackingWorkoutPage>(
      listener: (context, state) {
        if (state == FitnessTrackingWorkoutPage.all) {
          BlocProvider.of<WorkoutsListBloc>(context).add(WorkoutsListLoadRequested());
        }
      },
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
          ],
          onTap: (index) {
            BlocProvider.of<FitnessTrackingViewCubit>(context).viewUpdated(index);
          },
        );
      },
    );
  }
}
