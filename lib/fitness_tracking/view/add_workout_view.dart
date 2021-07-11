import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
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
              create: (context) => AddWorkoutFloatingActionButtonCubit(
                addWorkoutViewCubit: BlocProvider.of<AddWorkoutViewCubit>(context),
              ),
            )
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
      body: Column(
        children: [
          const AddWorkoutFormSelectedViewDisplayer(),
          Expanded(
            child: PageView(
              children: [
                const WorkoutForm(),
                const WorkoutDaysForm(),
              ],
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                BlocProvider.of<AddWorkoutViewCubit>(context).viewIndexUpdated(index);
              },
              physics: const BouncingScrollPhysics(),
            ),
          )
        ],
      ),
    );
  }
}
