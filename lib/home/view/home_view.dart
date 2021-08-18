import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/home/home.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/shared/widgets/app_drawer.dart';
import 'package:fit_tip/water_tracking/view/view.dart';
import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:fit_tip/weight_tracking/view/view.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:water_repository/water_repository.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeViewSelectorCubit(),
            ),
            BlocProvider<DaySelectorBloc>(
              create: (context) => DaySelectorBloc(),
            ),
            BlocProvider<CalorieDailyGoalBloc>(
              create: (context) => CalorieDailyGoalBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                foodRepository: RepositoryProvider.of<FoodRepository>(context),
              )..add(CalorieDailyGoalFocusedDateUpdated(date: BlocProvider.of<DaySelectorBloc>(context).state.selectedDate)),
            ),
            BlocProvider<FoodDailyLogsBloc>(
              create: (context) => FoodDailyLogsBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                foodRepository: RepositoryProvider.of<FoodRepository>(context),
              )..add(FoodDailyLogsFocusedDateUpdated(BlocProvider.of<DaySelectorBloc>(context).state.selectedDate)),
            ),
            BlocProvider<DaySelectorBloc>(
              create: (context) => DaySelectorBloc(),
            ),
            BlocProvider<WaterLogDayBloc>(
              create: (context) => WaterLogDayBloc(
                waterRepository: RepositoryProvider.of<WaterRepository>(context),
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              )..add(WaterLogFocusedDayUpdated(BlocProvider.of<DaySelectorBloc>(context).state.selectedDate)),
            ),
            BlocProvider<WaterDailyGoalBloc>(create: (context) {
              return WaterDailyGoalBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                waterRepository: RepositoryProvider.of<WaterRepository>(context),
              )..add(WaterDailyGoalDateUpdated(BlocProvider.of<DaySelectorBloc>(context).state.selectedDate));
            }),
            BlocProvider<WaterLogConsumptionBloc>(
              create: (context) => WaterLogConsumptionBloc(
                waterDailyGoalBloc: BlocProvider.of<WaterDailyGoalBloc>(context),
                waterLogDayBloc: BlocProvider.of<WaterLogDayBloc>(context),
              ),
            ),
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
          ],
          child: HomeView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text('Logout'),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeViewSelectorCubit, HomeViewSelectorState>(
        builder: (context, state) {
          if (state.isExcercise) {
            return ExcerciseDailyTrackingView.body();
          }
          if (state.isFood) {
            return FoodDailyLogsView.body();
          }
          if (state.isWater) {
            return WaterLogView.body();
          }
          if (state.isWeight) {
            return WeightTrackingView();
          }

          return Container();
        },
      ),
      bottomNavigationBar: HomeViewSelector(),
    );
  }
}
