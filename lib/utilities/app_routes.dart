import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/home.dart';
import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_repository/weight_repository.dart';

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
    WeightHistoryView.routeName: (BuildContext context) {
      BlocProvider.of<WeightHistoryBloc>(context).add(WeightHistoryLoad());

      return WeightHistoryView();
    },
    AddWeightView.routeName: (BuildContext context) {
      return BlocProvider<AddWeightFormBloc>(
        create: (context) => AddWeightFormBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          weightRepository: RepositoryProvider.of<WeightRepository>(context),
        ),
        child: AddWeightView(),
      );
    }
  };
}
