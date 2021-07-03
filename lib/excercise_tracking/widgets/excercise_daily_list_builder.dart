import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../excercise_tracking.dart';

class ExcerciseDailyListBuilder extends StatelessWidget {
  const ExcerciseDailyListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcerciseDailyListBloc, ExcerciseDailyListState>(
      builder: (context, state) {
        if (state is ExcerciseDailyListLoading) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is ExcerciseDailyListFailure) {
          return Center(
            child: Text('Oops something went wrong'),
          );
        } else if (state is ExcerciseDailyListLoadSuccess) {
          return SingleChildScrollView(
            child: Column(
              children: [
                //TODO: Daily goals
                ExcerciseDailyList(excercises: state.excercises),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}
