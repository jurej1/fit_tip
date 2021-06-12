import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

class FoodDailyLogsView extends StatelessWidget {
  const FoodDailyLogsView({Key? key}) : super(key: key);

  // static const routeName = 'food_daily_logs_view';

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<FoodLogFocusedDateBloc>(
            create: (context) => FoodLogFocusedDateBloc(),
          ),
          BlocProvider<CalorieDailyGoalBloc>(
            create: (context) => CalorieDailyGoalBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              foodRepository: RepositoryProvider.of<FoodRepository>(context),
            )..add(CalorieDailyGoalFocusedDateUpdated(date: BlocProvider.of<FoodLogFocusedDateBloc>(context).state.selectedDate)),
          ),
          BlocProvider<FoodDailyLogsBloc>(
            create: (context) => FoodDailyLogsBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              foodRepository: RepositoryProvider.of<FoodRepository>(context),
            )..add(FoodDailyLogsFocusedDateUpdated(BlocProvider.of<FoodLogFocusedDateBloc>(context).state.selectedDate)),
          )
        ],
        child: FoodDailyLogsView(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily logs'),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            FoodLogDaySelector(),
            FoodLogBuilder(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(AddFoodLogView.route(context));
        },
      ),
    );
  }
}
