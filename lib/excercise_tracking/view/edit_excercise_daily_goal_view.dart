import 'package:activity_repository/activity_repository.dart';
import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fit_tip/excercise_tracking/blocs/edit_excercise_daily_goal/edit_excercise_daily_goal_bloc.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditExcerciseDailyGoalView extends StatelessWidget {
  const EditExcerciseDailyGoalView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    final daySelectorBloc = BlocProvider.of<DaySelectorBloc>(context);

    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => EditExcerciseDailyGoalBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                activityRepository: RepositoryProvider.of<ActivityRepository>(context),
                daySelectorBloc: daySelectorBloc,
              ),
            )
          ],
          child: EditExcerciseDailyGoalView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit excercise daily goal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              BlocProvider.of<EditExcerciseDailyGoalBloc>(context).add(EditExcerciseDailyGoalFormSubmited());
            },
          ),
        ],
      ),
    );
  }
}
