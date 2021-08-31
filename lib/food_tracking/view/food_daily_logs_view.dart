import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

class FoodDailyLogsView extends StatelessWidget {
  const FoodDailyLogsView({Key? key}) : super(key: key);

  static List<BlocProvider> _providers() => [
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
        )
      ];

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return FoodDailyLogsView.widget(context);
      },
    );
  }

  static Widget widget(BuildContext context) {
    return MultiBlocProvider(
      providers: _providers(),
      child: FoodDailyLogsView(),
    );
  }

  static AppBar appBar(context) {
    return AppBar(
      title: Text('Food'),
      actions: [
        BlocBuilder<CalorieDailyGoalBloc, CalorieDailyGoalState>(
          builder: (context, state) {
            if (state is CalorieDailyGoalLoadSuccess) {
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(EditCalorieDailyGoalView.route(context));
                },
              );
            }
            return Container();
          },
        )
      ],
    );
  }

  static Widget body() {
    return Column(
      children: [
        FoodLogDaySelector(),
        FoodLogBuilder(),
      ],
    );
  }

  static FloatingActionButton floatingActionButton(context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).push(AddFoodLogView.route(context));
      },
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
