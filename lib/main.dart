import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:water_repository/water_repository.dart';
import 'package:weight_repository/weight_repository.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'app.dart';
import 'utilities/fit_tip_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory docDirectory = await path.getApplicationDocumentsDirectory();

  Hive.init(docDirectory.path);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: docDirectory,
  );
  await Firebase.initializeApp();

  Bloc.observer = FitTipBlocObserver();

  Box<String?> activeWorkoutBox = await Hive.openBox<String?>('activeWorkoutsBox');

  runApp(
    App(
      authenticationRepository: AuthenticationRepository(),
      weightRepository: WeightRepository(),
      waterRepository: WaterRepository(),
      foodRepository: FoodRepository(),
      fitnessRepository: FitnessRepository(activeWorkoutIdsBox: activeWorkoutBox),
      blogRepository: BlogRepository(),
    ),
  );
}
