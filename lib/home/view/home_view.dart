import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/home/home.dart';
import 'package:fit_tip/shared/widgets/app_drawer.dart';
import 'package:fit_tip/water_tracking/view/view.dart';
import 'package:fit_tip/weight_tracking/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            ...ExcerciseDailyTrackingView.providers(),
            ...FoodDailyLogsView.providers(),
            ...WaterLogView.providers(),
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
            child: Text('Logout'),
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
            return ExcerciseDailyTrackingView();
          }
          if (state.isFood) {
            return FoodDailyLogsView();
          }
          if (state.isWater) {
            return WaterLogView();
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
