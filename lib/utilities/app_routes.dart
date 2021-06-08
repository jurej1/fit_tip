import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/blocs/add_food_item/add_food_item_bloc.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/home.dart';
import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/view/view.dart';
import 'package:fit_tip/weight_statistics/weight_statistics.dart';
import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:water_repository/water_repository.dart';
import 'package:weight_repository/weight_repository.dart' as weight_rep;

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    RegisterView.routeName: (BuildContext context) {
      return BlocProvider<RegisterFormBloc>(
        create: (context) => RegisterFormBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context)),
        child: RegisterView(),
      );
    },
    LoginView.routeName: (BuildContext context) {
      return BlocProvider<LoginFormBloc>(
        create: (context) => LoginFormBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context)),
        child: LoginView(),
      );
    },
    Home.routeName: (BuildContext context) => Home(),
    WeightTrackingView.routeName: (BuildContext context) {
      BlocProvider.of<WeightHistoryBloc>(context).add(WeightHistoryLoad());
      BlocProvider.of<WeightGoalBloc>(context).add(WeightGoalLoadEvent());
      return WeightTrackingView();
    },
    AddWeightView.routeName: (BuildContext context) {
      final weight_rep.Weight? weight = ModalRoute.of(context)!.settings.arguments as weight_rep.Weight;
      return BlocProvider<AddWeightFormBloc>(
        create: (context) => AddWeightFormBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          weightRepository: RepositoryProvider.of<weight_rep.WeightRepository>(context),
          weight: weight,
        ),
        child: AddWeightView(),
      );
    },
    WeightStatisticsView.routeName: (BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<WeightStatisticsBloc>(
            create: (context) => WeightStatisticsBloc(
              weightHistoryBloc: BlocProvider.of<WeightHistoryBloc>(context),
              weightRepository: RepositoryProvider.of<weight_rep.WeightRepository>(context),
            ),
          ),
          BlocProvider<WeightGoalStatisticsBloc>(
            create: (context) => WeightGoalStatisticsBloc(
              weightGoalBloc: BlocProvider.of<WeightGoalBloc>(context),
              weightRepository: RepositoryProvider.of<weight_rep.WeightRepository>(context),
              weightHistoryBloc: BlocProvider.of<WeightHistoryBloc>(context),
            ),
          ),
        ],
        child: WeightStatisticsView(),
      );
    },
    EditWeightGoalView.routeName: (BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<EditWeightGoalFormBloc>(
            create: (context) => EditWeightGoalFormBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              weightGoalBloc: BlocProvider.of<WeightGoalBloc>(context),
              weightRepository: RepositoryProvider.of<weight_rep.WeightRepository>(context),
            ),
          ),
        ],
        child: EditWeightGoalView(),
      );
    },
    WaterLogView.routeName: (BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<WaterLogFocusedDayBloc>(
            create: (context) => WaterLogFocusedDayBloc(),
          ),
          BlocProvider<WaterLogDayBloc>(
            create: (context) => WaterLogDayBloc(
              waterRepository: RepositoryProvider.of<WaterRepository>(context),
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            )..add(WaterLogFocusedDayUpdated(BlocProvider.of<WaterLogFocusedDayBloc>(context).state.selectedDate)),
          ),
          BlocProvider<WaterDailyGoalBloc>(create: (context) {
            return WaterDailyGoalBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              waterRepository: RepositoryProvider.of<WaterRepository>(context),
            )..add(WaterDailyGoalDateUpdated(BlocProvider.of<WaterLogFocusedDayBloc>(context).state.selectedDate));
          }),
          BlocProvider<WaterLogConsumptionBloc>(
            create: (context) => WaterLogConsumptionBloc(
              waterDailyGoalBloc: BlocProvider.of<WaterDailyGoalBloc>(context),
              waterLogDayBloc: BlocProvider.of<WaterLogDayBloc>(context),
            ),
          ),
        ],
        child: WaterLogView(),
      );
    },
    AddWaterDailyGoalView.routeName: (BuildContext context) {
      final Map<int, dynamic> map = ModalRoute.of(context)!.settings.arguments as Map<int, dynamic>;

      final WaterDailyGoalBloc waterDailyGoalBloc = map[0];
      final WaterLogFocusedDayBloc waterLogFocusedDayBloc = map[1];
      return MultiBlocProvider(
        providers: [
          BlocProvider<AddWaterDailyGoalBloc>(
            create: (context) => AddWaterDailyGoalBloc(
              waterLogFocusedDayBloc: waterLogFocusedDayBloc,
              waterRepository: RepositoryProvider.of<WaterRepository>(context),
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            ),
          ),
          BlocProvider.value(
            value: waterDailyGoalBloc,
          ),
        ],
        child: AddWaterDailyGoalView(),
      );
    },
    FoodDailyLogsView.routeName: (BuildContext context) {
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
    },
    AddFoodLogView.routeName: (BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AddFoodItemBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              foodRepository: RepositoryProvider.of<FoodRepository>(context),
            ),
            child: Container(),
          )
        ],
        child: AddFoodLogView(),
      );
    }
  };
}
