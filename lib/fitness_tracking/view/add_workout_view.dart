import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddWorkoutView extends StatelessWidget {
  const AddWorkoutView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AddWorkoutViewCubit(),
            ),
            BlocProvider(
              create: (_) => AddWorkoutFormBloc(),
            ),
            BlocProvider(
              create: (context) => WorkoutsDaysListBloc(
                addWorkoutFormBloc: BlocProvider.of<AddWorkoutFormBloc>(context),
              ),
            ),
          ],
          child: AddWorkoutView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddWorkoutViewAppBar(),
      body: BlocBuilder<AddWorkoutViewCubit, AddWorkoutFormView>(
        builder: (context, view) {
          return Column(
            children: [
              const AddWorkoutFormSelectedViewDisplayer(),
              Expanded(
                child: PageView(
                  children: [
                    const WorkoutForm(),
                    const WorkoutDaysForm(),
                  ],
                  onPageChanged: (index) {
                    BlocProvider.of<AddWorkoutViewCubit>(context).viewIndexUpdated(index);
                  },
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: AddExcerciseFloatingActionButton(),
    );
  }
}
