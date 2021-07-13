import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/widgets/widgets.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class AddWorkoutDayView extends StatelessWidget {
  AddWorkoutDayView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, {required WorkoutDay workoutDay}) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddWorkoutDayFormBloc(workoutDay: workoutDay),
            ),
          ],
          child: AddWorkoutDayView(),
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
          const _WorkoutInput(),
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
    return BlocConsumer<AddWorkoutDayFormBloc, AddWorkoutDayFormState>(
      listener: (context, state) {
        if (state.muscleGroupList.containsMoreThanTwoMuscleGroups) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('We recommend two muscle groups per workout'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Muscle groups'),
                IconButton(
                  onPressed: () async {
                    MuscleGroup? value = await showCustomModalBottomSheet<MuscleGroup?>(
                      context,
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            final item = state.getAvailableMuscleGroups()[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              title: Text(describeEnum(item)),
                              onTap: () {
                                Navigator.of(context).pop(item);
                              },
                            );
                          },
                          itemCount: state.getAvailableMuscleGroups().length,
                        ),
                      ),
                    );

                    BlocProvider.of<AddWorkoutDayFormBloc>(context).add(AddWorkoutDayMuscleGroupAdded(value));
                  },
                  icon: const Icon(Icons.add),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 10,
              children: state.getMuscleGroupList().map(
                (e) {
                  return Chip(
                    key: ValueKey(e),
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

class _WorkoutInput extends StatelessWidget {
  const _WorkoutInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutDayFormBloc, AddWorkoutDayFormState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Workouts'),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(AddWorkoutExcerciseView.route(context));
                  },
                  icon: const Icon(Icons.add),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: state.getExcercisesList().length,
            //   itemBuilder: (context, index) {
            //     final item = state.getExcercisesList()[index];
            //     return ListTile(
            //       dense: true,
            //       title: Text(item.name),
            //     );
            //   },
            // ),
            if (state.getExcercisesList().isNotEmpty)
              DataTable(
                columns: [
                  DataColumn(
                    label: Text('Name'),
                  ),
                  DataColumn(
                    label: Text('Sets'),
                  ),
                  DataColumn(
                    label: Text('Reps'),
                  )
                ],
                rows: state.getExcercisesList().map(
                  (e) {
                    return DataRow(
                      cells: [
                        DataCell(Text(e.name)),
                        DataCell(Text(e.sets.toStringAsFixed(0))),
                        DataCell(Text('${e.reps} ${describeEnum(e.repUnit)}'))
                      ],
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
