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
              const _SelectedViewDisplayer(),
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
    );
  }
}

class _SelectedViewDisplayer extends StatefulWidget {
  const _SelectedViewDisplayer({Key? key}) : super(key: key);

  @override
  __SelectedViewDisplayerState createState() => __SelectedViewDisplayerState();
}

class __SelectedViewDisplayerState extends State<_SelectedViewDisplayer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      upperBound: AddWorkoutFormView.values.length.toDouble(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddWorkoutViewCubit, AddWorkoutFormView>(
      listener: (context, view) {
        _controller.animateTo(AddWorkoutFormView.values.indexOf(view).toDouble());
      },
      child: Container(
        height: 30,
        child: SelectedViewDisplayer(
          controller: _controller,
          dotSize: 10,
          length: AddWorkoutFormView.values.length,
          selectedColor: Colors.blue,
          unselectedColor: Colors.grey.shade300,
          width: 40,
        ),
      ),
    );
  }
}
