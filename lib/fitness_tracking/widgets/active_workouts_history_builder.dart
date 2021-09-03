import 'package:fit_tip/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class ActiveWorkoutsHistoryBuilder extends StatelessWidget {
  const ActiveWorkoutsHistoryBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active workouts history'),
      ),
      body: BlocBuilder<ActiveWorkoutsHistoryListBloc, ActiveWorkoutsHistoryListState>(
        builder: (context, state) {
          if (state is ActiveWorkoutsHistoryListLoading) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          } else if (state is ActiveWorkoutsHistoryListLoadSuccess) {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: state.hasReachedMax ? state.workouts.length : state.workouts.length + 1,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = state.workouts[index];
                return WorkoutsListCard.route(context, item.info);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: FitnessTrackingViewSelector(),
    );
  }
}
