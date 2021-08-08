import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<ExcercisePageCardBloc, ExcercisePageCardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 100,
                    width: size.width * 0.5,
                    color: Colors.red,
                    // child: DraggableValueSelector.route(itemHeight: 20, onValueUpdated: (value) {}, itemCount: 20, height: 80),
                    child: ScrollableHorizontalValueSelector(
                      mode: DurationSelectorValueMode.x,
                      onValueUpdated: (value) {},
                      width: size.width * 0.5,
                      initialIndex: 10,
                      itemsLength: 20,
                    ),
                  ),
                  Container(
                    height: 100,
                    width: size.width * 0.5,
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
