import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../fitness_tracking.dart';

class AddWorkoutDayView extends StatelessWidget {
  AddWorkoutDayView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, {required WorkoutDay workoutDay}) {
    final workoutBloc = BlocProvider.of<AddWorkoutFormBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddWorkoutDayFormBloc(workoutDay: workoutDay),
            ),
            BlocProvider.value(value: workoutBloc),
          ],
          child: AddWorkoutDayView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddWorkoutDayFormBloc, AddWorkoutDayFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormListItemUpdated(state.workoutDay));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add workout day'),
          actions: [
            const _SubmitButton(),
          ],
        ),
        body: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          children: [
            const _DayInput(),
            const _NoteInput(),
            const _MuscleGroupsInput(),
            _WorkoutInput(),
          ],
        ),
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
                    child: Text(WorkoutDay.mapListIndexToText(index - 1)),
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
      listenWhen: (p, c) => p.muscleGroupList.value?.length != c.muscleGroupList.value?.length,
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
                    FocusScope.of(context).unfocus();

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
  _WorkoutInput({Key? key}) : super(key: key);

  final TextStyle columnTitleStyle = TextStyle(
    fontWeight: FontWeight.w700,
  );

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
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).push(AddWorkoutExcerciseView.route(context));
                  },
                  icon: const Icon(Icons.add),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Row(
              children: [
                RowExcerciseData(
                  text: 'Name',
                  style: columnTitleStyle,
                ),
                RowExcerciseData(
                  text: 'Sets',
                  style: columnTitleStyle,
                ),
                RowExcerciseData(
                  text: 'Reps',
                  style: columnTitleStyle,
                ),
              ],
            ),
            ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 1,
                  child: ColoredBox(
                    color: Colors.black26,
                  ),
                );
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.getExcercisesList().length,
              itemBuilder: (context, index) {
                final item = state.getExcercisesList()[index];
                return Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(AddWorkoutExcerciseView.route(context, excercise: item));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          RowExcerciseData(text: '${item.name}'),
                          RowExcerciseData(text: '${item.sets}'),
                          RowExcerciseData(text: '${item.reps} ${describeEnum(item.repUnit)}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class RowExcerciseData extends StatelessWidget {
  const RowExcerciseData({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutDayFormBloc, AddWorkoutDayFormState>(
      builder: (context, state) {
        final bool isVisible = !state.status.isPure;

        return Visibility(
          visible: isVisible,
          child: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              BlocProvider.of<AddWorkoutDayFormBloc>(context).add(AddWorkoutDayFormSubmited());
            },
            icon: Icon(Icons.check),
          ),
        );
      },
    );
  }
}
