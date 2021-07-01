import 'package:activity_repository/activity_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/activity_tracking.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/shared/blocs/day_selector/day_selector_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExcerciseDailyTrackingView extends StatelessWidget {
  const ExcerciseDailyTrackingView({Key? key}) : super(key: key);

  static route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => DaySelectorBloc(),
            ),
            BlocProvider(
              create: (context) => ExcerciseDailyListBloc(
                activityRepository: RepositoryProvider.of<ActivityRepository>(context),
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              )..add(ExcerciseDailyListDateUpdated(BlocProvider.of<DaySelectorBloc>(context).state.selectedDate)),
            ),
          ],
          child: ExcerciseDailyTrackingView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excercise tracking'),
      ),
      body: Column(
        children: [
          ExcerciseDaySelector(),
        ],
      ),
    );
  }
}
