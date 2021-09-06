import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class FitnessWorkoutsViewSelector extends StatelessWidget {
  const FitnessWorkoutsViewSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessWorkoutsViewSelectorCubit, FitnessWorkoutsViewSelectorState>(
      builder: (context, value) {
        return BottomNavigationBar(
          currentIndex: FitnessWorkoutsViewSelectorState.values.indexOf(value),
          items: FitnessWorkoutsViewSelectorState.values
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Icon(e.toIconData()),
                  label: e.toStringReadable(),
                ),
              )
              .toList(),
          onTap: (index) {
            BlocProvider.of<FitnessWorkoutsViewSelectorCubit>(context).viewUpdatedIndex(index);
          },
        );
      },
    );
  }
}
