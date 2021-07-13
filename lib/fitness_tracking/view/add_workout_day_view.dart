import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddWorkoutDayView extends StatelessWidget {
  const AddWorkoutDayView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, {required WorkoutDay workoutDay}) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddWorkoutDayFormBloc(workoutDay: workoutDay),
            ),
          ],
          child: const AddWorkoutDayView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add workout day'),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(10),
        children: [
          const _DayInput(),
          const _NoteInput(),
          const _MuscleGroupsInput(),
        ],
      ),
    );
  }
}

class _DayInput extends StatelessWidget {
  const _DayInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutDayFormBloc, AddWorkoutDayFormState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Day'),
            DropdownButton<int>(
              value: state.day.value,
              items: List.generate(
                7,
                (index) {
                  return DropdownMenuItem(
                    child: Text(state.mapDayToText(index)),
                    value: index,
                    key: ValueKey(index),
                  );
                },
              ),
              onChanged: (value) {
                BlocProvider.of<AddWorkoutDayFormBloc>(context).add(AddWorkoutDayDayChanged(value));
              },
            ),
          ],
        );
      },
    );
  }
}

class _NoteInput extends StatelessWidget {
  const _NoteInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutDayFormBloc, AddWorkoutDayFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.note.value,
          decoration: InputDecoration(
            errorText: state.note.invalid ? 'Invalid' : null,
            labelText: 'Note (Optional)',
          ),
          onChanged: (value) {
            BlocProvider.of<AddWorkoutDayFormBloc>(context).add(AddWorkoutDayNoteChanged(value));
          },
        );
      },
    );
  }
}

class _MuscleGroupsInput extends StatelessWidget {
  const _MuscleGroupsInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutDayFormBloc, AddWorkoutDayFormState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Muscle groups'),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return Container();
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Wrap(
              children: state.getMuscleGroupList().map(
                (e) {
                  return Chip(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    label: Text(describeEnum(e)),
                    onDeleted: () {
                      BlocProvider.of<AddWorkoutDayFormBloc>(context).add(AddWorkoutDayMuscleGroupRemoved(e));
                    },
                  );
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}
