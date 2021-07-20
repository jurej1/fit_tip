import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutInfoRow extends StatelessWidget {
  const WorkoutInfoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<WorkoutDetailViewBloc, WorkoutDetailViewState>(
      builder: (context, state) {
        return Container(
          width: size.width,
          child: Align(
            alignment: Alignment(0, 0.5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        const SizedBox(height: 5),
                        Text('Created'),
                        const SizedBox(height: 5),
                        Text(state.workout.mapCreatedToState),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        const SizedBox(height: 5),
                        Text('Days Per Week'),
                        const SizedBox(height: 5),
                        Text(state.workout.daysPerWeek.toStringAsFixed(0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        const SizedBox(height: 5),
                        Text('Created'),
                        const SizedBox(height: 5),
                        Text(state.workout.mapCreatedToState),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
