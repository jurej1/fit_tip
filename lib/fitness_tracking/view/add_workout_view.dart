import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddWorkoutView extends StatelessWidget {
  const AddWorkoutView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(builder: (_) {
      return MultiBlocProvider(
        providers: [],
        child: AddWorkoutView(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
