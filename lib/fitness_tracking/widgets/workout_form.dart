import 'dart:math';

import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../fitness_tracking.dart';

class WorkoutForm extends StatelessWidget {
  const WorkoutForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      physics: const BouncingScrollPhysics(),
      children: [
        const _WorkoutTitleInput(),
        const _WorkoutNoteInput(),
        const _WorkoutGoalInput(),
        const _WorkoutTypeInput(),
        const _WorkoutDurationInput(),
        const _WorkoutDaysPerWeekInput(),
        const _WorkoutTimePerWorkoutInput(),
        const _WorkoutStartDateInput(),
      ],
    );
  }
}

class _WorkoutTitleInput extends HookWidget {
  const _WorkoutTitleInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = useAnimationController(
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 2 * pi,
    );
    return BlocConsumer<AddWorkoutFormBloc, AddWorkoutFormState>(
      listenWhen: (p, c) => p.title != c.title,
      listener: (context, state) {
        if (state.title.invalid) {
          _controller.forward().then((value) => _controller.reset());
        }
      },
      builder: (context, state) {
        return ShakeAnimationBuilder(
          controller: _controller,
          child: TextFormField(
            initialValue: state.title.value,
            decoration: InputDecoration(
              errorText: state.title.invalid ? 'Invalid' : null,
              labelText: 'Title',
            ),
            onChanged: (value) {
              BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormTitleUpdated(value));
            },
          ),
        );
      },
    );
  }
}

class _WorkoutNoteInput extends HookWidget {
  const _WorkoutNoteInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 2 * pi,
    );
    return BlocConsumer<AddWorkoutFormBloc, AddWorkoutFormState>(
      listenWhen: (p, c) => p.note != c.note,
      listener: (context, state) {
        if (state.note.invalid) {
          _controller.forward().then((value) => _controller.reset());
        }
      },
      builder: (context, state) {
        return ShakeAnimationBuilder(
          controller: _controller,
          child: TextFormField(
            initialValue: state.note.value,
            decoration: InputDecoration(
              errorText: state.note.invalid ? 'Invalid' : null,
              labelText: 'Note (Optional)',
            ),
            onChanged: (value) {
              BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormNoteUpdated(value));
            },
          ),
        );
      },
    );
  }
}

class _WorkoutGoalInput extends HookWidget {
  const _WorkoutGoalInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 2 * pi,
    );

    return BlocConsumer<AddWorkoutFormBloc, AddWorkoutFormState>(
      listenWhen: (p, c) => p.goal != c.goal,
      listener: (context, state) {
        if (state.goal.invalid) {
          _controller.forward().then((value) => _controller.reset());
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Main goal'),
            ShakeAnimationBuilder(
              controller: _controller,
              child: DropdownButton(
                value: state.goal.value,
                items: WorkoutGoal.values
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(mapWorkoutGoalToText(e)),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (WorkoutGoal? goal) {
                  BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormGoalUpdated(goal));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WorkoutTypeInput extends HookWidget {
  const _WorkoutTypeInput({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = useAnimationController(
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 2 * pi,
    );

    return BlocConsumer<AddWorkoutFormBloc, AddWorkoutFormState>(
      listenWhen: (p, c) => p.type != c.type,
      listener: (context, state) {
        if (state.type.invalid) {
          _controller.forward().then((value) => _controller.reset());
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Type '),
            ShakeAnimationBuilder(
              key: ValueKey('type '),
              controller: _controller,
              child: DropdownButton(
                value: state.type.value,
                items: WorkoutType.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          mapWorkoutTypeToString(e),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (WorkoutType? value) {
                  BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormTypeUpdated(value));
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class _WorkoutDurationInput extends HookWidget {
  const _WorkoutDurationInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = useAnimationController(
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 2 * pi,
    );

    return BlocConsumer<AddWorkoutFormBloc, AddWorkoutFormState>(
      listenWhen: (p, c) => p.duration != c.duration,
      listener: (context, state) {
        if (state.duration.invalid) {
          _controller.forward().then((value) => _controller.reset());
        }
      },
      builder: (context, state) {
        return ShakeAnimationBuilder(
          key: ValueKey('duration'),
          controller: _controller,
          child: RowInputField(
            initialValue: state.duration.value,
            onChanged: (val) {
              BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormDurationUpdated(val));
            },
            unit: 'weeks',
            title: 'Duration',
            keyboardType: TextInputType.number,
          ),
        );
      },
    );
  }
}

class _WorkoutDaysPerWeekInput extends HookWidget {
  const _WorkoutDaysPerWeekInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = useAnimationController(
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 2 * pi,
    );
    return BlocConsumer<AddWorkoutFormBloc, AddWorkoutFormState>(
      listenWhen: (p, c) => p.daysPerWeek != c.daysPerWeek,
      listener: (context, state) {
        if (state.daysPerWeek.invalid) {
          _controller.forward().then((value) => _controller.reset());
        }
      },
      builder: (context, state) {
        return ShakeAnimationBuilder(
          controller: _controller,
          child: RowInputField(
            initialValue: state.daysPerWeek.value,
            onChanged: (value) {
              BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormDaysPerWeekUpdated(value));
            },
            unit: 'x',
            title: 'Days per week',
            keyboardType: TextInputType.number,
          ),
        );
      },
    );
  }
}

class _WorkoutTimePerWorkoutInput extends HookWidget {
  const _WorkoutTimePerWorkoutInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = useAnimationController(
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 2 * pi,
    );
    return BlocConsumer<AddWorkoutFormBloc, AddWorkoutFormState>(
      listenWhen: (p, c) => p.timePerWorkout != c.timePerWorkout,
      listener: (context, state) {
        if (state.timePerWorkout.invalid) {
          _controller.forward().then((value) => _controller.reset());
        }
      },
      builder: (context, state) {
        return ShakeAnimationBuilder(
          controller: _controller,
          child: RowInputField(
            initialValue: state.timePerWorkout.value,
            onChanged: (val) {
              BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormTimePerWorkoutUpdated(val));
            },
            unit: 'min',
            title: 'Time per workout',
            keyboardType: TextInputType.number,
          ),
        );
      },
    );
  }
}

class _WorkoutStartDateInput extends HookWidget {
  const _WorkoutStartDateInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 2 * pi,
    );
    return BlocConsumer<AddWorkoutFormBloc, AddWorkoutFormState>(
      listenWhen: (p, c) => p.startDate != c.startDate,
      listener: (context, state) {
        if (state.startDate.invalid) {
          _controller.forward().then((value) => _controller.reset());
        }
      },
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Start date:',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          trailing: ShakeAnimationBuilder(
            controller: _controller,
            child: Text(
              DateFormat('dd.MMMM.yyy').format(state.startDate.value),
            ),
          ),
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: state.startDate.value,
              firstDate: BlocProvider.of<UserDataBloc>(context).state.user!.dateJoined!,
              lastDate: DateTime.now(),
            );

            BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormStartDateUpdated(date));
          },
        );
      },
    );
  }
}
