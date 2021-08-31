import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:fit_tip/excercise_tracking/view/add_excercise_log_view.dart';
import 'package:fit_tip/shared/blocs/day_selector/day_selector_bloc.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExcerciseDailyTrackingView extends StatelessWidget {
  const ExcerciseDailyTrackingView({Key? key}) : super(key: key);

  static List<BlocProvider> _providers() => [
        BlocProvider(
          create: (context) => DaySelectorBloc(),
        ),
        BlocProvider(
          create: (context) => ExcerciseDailyListBloc(
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          )..add(ExcerciseDailyListDateUpdated(BlocProvider.of<DaySelectorBloc>(context).state.selectedDate)),
        ),
        BlocProvider(
          create: (context) => ExcerciseDailyGoalBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
          )..add(ExcerciseDailyGoalDateUpdated(BlocProvider.of<DaySelectorBloc>(context).state.selectedDate)),
        ),
      ];

  static List<BlocProvider> providers() => [..._providers()];

  static route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return ExcerciseDailyTrackingView.widget(context);
      },
    );
  }

  static widget(BuildContext context) {
    return MultiBlocProvider(
      providers: _providers(),
      child: ExcerciseDailyTrackingView(),
    );
  }

  static AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text('Excercise'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(EditExcerciseDailyGoalView.route(context));
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }

  static FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).push(AddExcerciseLogView.route(context));
      },
    );
  }

  static Widget body() {
    return Column(
      children: [
        ExcerciseDaySelector(),
        ExcerciseDailyListBuilder(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: body(),
      ),
      floatingActionButton: floatingActionButton(context),
    );
  }
}
