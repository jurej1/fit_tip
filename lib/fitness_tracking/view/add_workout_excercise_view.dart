import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class AddWorkoutExcerciseView extends StatelessWidget {
  const AddWorkoutExcerciseView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddWorkoutExcerciseFormBloc(),
            ),
          ],
          child: AddWorkoutExcerciseView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout Excercise View'),
      ),
      body: ListView(
        children: [
          const _RepsInput(),
          const _SetsInput(),
        ],
      ),
    );
  }
}

class _RepsInput extends StatelessWidget {
  const _RepsInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutExcerciseFormBloc, AddWorkoutExcerciseFormState>(
      builder: (context, state) {
        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Reps',
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
              DraggableValueSelector.route(
                itemHeight: 30,
                itemCount: 61,
                focusedValue: state.reps.value,
                onValueUpdated: (value) {
                  BlocProvider.of<AddWorkoutExcerciseFormBloc>(context).add(AddWorkoutExcerciseRepsUpdated(value));
                },
                height: 75,
              ),
              RepUnitValueSelector.route(
                itemHeight: 20,
                height: 75,
                initialValue: state.repUnit.value,
                onValueUpdated: (value) {
                  BlocProvider.of<AddWorkoutExcerciseFormBloc>(context).add(AddWorkoutExcerciseRepUnitUpdated(value));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SetsInput extends StatelessWidget {
  const _SetsInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutExcerciseFormBloc, AddWorkoutExcerciseFormState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sets',
              style: TextStyle(fontSize: 18),
            ),
            DraggableValueSelector.route(
              height: 75,
              itemHeight: 30,
              itemCount: 21,
              focusedValue: state.sets.value,
              onValueUpdated: (value) {
                BlocProvider.of<AddWorkoutExcerciseFormBloc>(context).add(AddWorkoutExcerciseSetsUpdated(value));
              },
            ),
          ],
        );
      },
    );
  }
}
