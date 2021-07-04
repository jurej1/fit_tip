import 'package:activity_repository/activity_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExcerciseDailyList extends StatelessWidget {
  const ExcerciseDailyList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcerciseDailyListBloc, ExcerciseDailyListState>(
      builder: (context, state) {
        if (state is ExcerciseDailyListLoadSuccess) {
          final int _length = state.excercises.length;
          if (_length == 0) {
            return Center(
              child: Text('You do not have any excercises.'),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: _length + 1,
            itemBuilder: (context, index) {
              if (index == _length) {
                return const SizedBox(height: 90);
              }
              final item = state.excercises[index];

              return BlocProvider(
                create: (context) => ExcerciseTileBloc(
                  excerciseLog: item,
                  activityRepository: RepositoryProvider.of<ActivityRepository>(context),
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
                child: ExcerciseTile(
                  key: ValueKey(item),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
