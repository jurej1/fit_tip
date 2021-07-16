import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../fitness_tracking.dart';

class AddWorkoutExcerciseView extends StatelessWidget {
  const AddWorkoutExcerciseView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    final workoutdDayBloc = BlocProvider.of<AddWorkoutDayFormBloc>(context);

    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddWorkoutExcerciseFormBloc(),
            ),
            BlocProvider.value(value: workoutdDayBloc),
          ],
          child: AddWorkoutExcerciseView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddWorkoutExcerciseFormBloc, AddWorkoutExcerciseFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<AddWorkoutDayFormBloc>(context).add(AddWorkoutDayExcerciseAdded(state.excercise));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Workout Excercise View'),
          actions: [
            const _SubmitButton(),
          ],
        ),
        body: BlocBuilder<AddWorkoutExcerciseFormBloc, AddWorkoutExcerciseFormState>(
          builder: (context, state) {
            if (state.status.isSubmissionInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  const _NameInput(),
                  const _SetsInput(),
                  const _RepsInput(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutExcerciseFormBloc, AddWorkoutExcerciseFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.name.value,
          decoration: InputDecoration(
            labelText: 'Name',
          ),
          onChanged: (value) {
            BlocProvider.of<AddWorkoutExcerciseFormBloc>(context).add(AddWorkoutExcerciseNameUpdated(value));
          },
        );
      },
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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutExcerciseFormBloc, AddWorkoutExcerciseFormState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            BlocProvider.of<AddWorkoutExcerciseFormBloc>(context).add(AddWorkoutExcerciseFormSubmitted());
          },
        );
      },
    );
  }
}
