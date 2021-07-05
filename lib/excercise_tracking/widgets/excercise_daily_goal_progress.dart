import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/blocs/excercise_daily_progress/excercise_daily_progress_bloc.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExcerciseDailyGoalProgress extends StatelessWidget {
  const ExcerciseDailyGoalProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: BlocProvider(
        create: (context) => ExcerciseDailyProgressBloc(
          excerciseDailyListBloc: BlocProvider.of<ExcerciseDailyListBloc>(context),
          excerciseDailyGoalBloc: BlocProvider.of<ExcerciseDailyGoalBloc>(context),
        ),
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcerciseDailyProgressBloc, ExcerciseDailyProgressState>(
      builder: (context, state) {
        if (state is ExcerciseDailyProgressLoadSuccess) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedProgressBar(
                primaryValue: state.getPrimaryValue().toDouble(),
                maxValue: state.getMaxValue().toDouble(),
                primaryColor: Colors.blue,
                secondaryColor: Colors.green,
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
