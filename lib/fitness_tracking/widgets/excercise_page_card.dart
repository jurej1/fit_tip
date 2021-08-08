import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';

class ExcercisePageCard extends StatelessWidget {
  const ExcercisePageCard({Key? key}) : super(key: key);

  static Widget provider(WorkoutExcercise excercise) {
    return BlocProvider(
      key: ValueKey(excercise),
      create: (context) => ExcercisePageCardBloc(excercise: excercise),
      child: ExcercisePageCard(
        key: ValueKey(excercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcercisePageCardBloc, ExcercisePageCardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'Goal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _GoalRowDisplayer(
                      title: 'Set goal',
                      value: '${state.excercise.setsString}x',
                    ),
                    _GoalRowDisplayer(
                      title: 'Rep goal',
                      value: '${state.excercise.repsString}x',
                    ),
                  ],
                ),
              ),
              ...List.generate(
                state.excercise.sets,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      '     Set ${index + 1}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    _SetDisplayer(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GoalRowDisplayer extends StatelessWidget {
  const _GoalRowDisplayer({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    );
  }
}

class _SetDisplayer extends StatelessWidget {
  const _SetDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double containerSize = 120;

    return Row(
      children: [
        Container(
          height: containerSize,
          width: size.width * 0.5,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.black),
            ),
          ),
          child: Column(
            children: [
              Text('Rep Count'),
              const SizedBox(height: 8),
              Expanded(
                child: ScrollableHorizontalValueSelector(
                  onValueUpdated: (value) {},
                  width: size.width * 0.5,
                  initialIndex: 10,
                  itemsLength: 40,
                  textBuilder: (value) {
                    return Text('$value');
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: containerSize,
          width: size.width * 0.5,
          // color: Colors.blue,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.black),
            ),
          ),
          child: Column(
            children: [
              Text('Weight'),
              const SizedBox(height: 8),
              Expanded(
                child: ScrollableHorizontalValueSelector(
                  onValueUpdated: (value) {},
                  width: size.width * 0.5,
                  initialIndex: 80,
                  itemsLength: 300,
                  textBuilder: (value) {
                    return Text('$value kg');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
