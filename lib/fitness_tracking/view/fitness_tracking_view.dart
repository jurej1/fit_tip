import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FitnessTrackingView extends StatelessWidget {
  const FitnessTrackingView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => FitnessTrackingViewCubit(),
            ),
            BlocProvider(
              create: (context) => WorkoutsListBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
              )..add(WorkoutsListLoadRequested()),
            ),
            BlocProvider(
              create: (context) => ActiveWorkoutBloc(
                workoutsListBloc: BlocProvider.of<WorkoutsListBloc>(context),
              ),
            ),
            BlocProvider(
              create: (context) => ActiveWorkoutViewSelectorCubit(),
            ),
          ],
          child: FitnessTrackingView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessTrackingViewCubit, FitnessTrackingWorkoutPage>(
      builder: (context, page) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fitness tracking'),
                Visibility(
                  visible: page == FitnessTrackingWorkoutPage.active,
                  child: _AppBarPageDisplayer(),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(AddWorkoutView.route(context));
                },
              ),
            ],
          ),
          body: _body(page),
          bottomNavigationBar: FitnessTrackingViewSelector(),
          floatingActionButton: Visibility(
            visible: page == FitnessTrackingWorkoutPage.active,
            child: FloatingActionButton.extended(
              onPressed: () {},
              label: Text('Start Workout'),
            ),
          ),
        );
      },
    );
  }

  Widget _body(FitnessTrackingWorkoutPage page) {
    if (page == FitnessTrackingWorkoutPage.active) {
      return ActiveWorkoutBuilder();
    }
    if (page == FitnessTrackingWorkoutPage.all) {
      return WorkoutsListBuilder();
    }

    return Container();
  }
}

class _AppBarPageDisplayer extends HookWidget {
  const _AppBarPageDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: ActiveWorkoutView.values.length.toDouble(),
    );
    return BlocListener<ActiveWorkoutViewSelectorCubit, ActiveWorkoutView>(
      listener: (context, state) {
        _controller.animateTo(ActiveWorkoutView.values.indexOf(state).toDouble());
      },
      child: SelectedViewDisplayer(
        unselectedColor: Colors.grey,
        width: 30,
        dotSize: 10,
        length: ActiveWorkoutView.values.length,
        controller: _controller,
        selectedColor: Colors.white,
      ),
    );
  }
}
