import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/home.dart';
import 'package:fit_tip/weight_statistics/weight_statistics.dart';
import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              weightGoalBloc: BlocProvider.of<WeightGoalBloc>(context),
              weightRepository: RepositoryProvider.of<weight_rep.WeightRepository>(context),
            ),
          ),
        ],
        child: EditWeightGoalView(),
      );
    }
  };
}
