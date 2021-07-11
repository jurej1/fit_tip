import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddWorkoutDayView extends StatelessWidget {
  const AddWorkoutDayView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        // return MultiBlocProvider(
        //   providers: [],
        //   child: AddWorkoutDayView(),
        // );

        return const AddWorkoutDayView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add workout day'),
      ),
    );
  }
}
