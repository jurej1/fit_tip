import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_repository/weight_repository.dart';

import 'app.dart';
import 'utilities/fit_tip_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = FitTipBlocObserver();

  runApp(
    App(
      authenticationRepository: AuthenticationRepository(),
      weightRepository: WeightRepository(),
    ),
  );
}
