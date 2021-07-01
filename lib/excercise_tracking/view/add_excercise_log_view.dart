import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExcerciseLogView extends StatelessWidget {
  const AddExcerciseLogView({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final excerciseDailyListBloc = BlocProvider.of<ExcerciseDailyListBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddExcerciseLogBloc(),
            ),
            BlocProvider.value(
              value: excerciseDailyListBloc,
            ),
          ],
          child: AddExcerciseLogView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Excercise Log'),
      ),
      body: Column(
        children: [
          DurationSelector(),
          BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
            builder: (context, state) {
              return Text('x = ${state.offset}; index = ${state.focusedIndex}');
            },
          ),
        ],
      ),
    );
  }
}
