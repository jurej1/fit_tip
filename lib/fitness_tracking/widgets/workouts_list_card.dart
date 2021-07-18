import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutsListCard extends StatelessWidget {
  const WorkoutsListCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutsListCardBloc, WorkoutsListCardState>(
      builder: (context, state) {
        return Container(
          child: ListTile(
            title: Text(state.workout.note),
          ),
        );
      },
    );
  }
}
