import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, {required Workout workout}) {
    final workoutsListBloc = BlocProvider.of<WorkoutsListBloc>(context);

    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => WorkoutDetailViewBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
                workout: workout,
              ),
            ),
            BlocProvider.value(value: workoutsListBloc),
          ],
          child: WorkoutDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<WorkoutDetailViewBloc, WorkoutDetailViewState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: state.appBarBorderRadius,
                ),
                centerTitle: true,
                backgroundColor: Colors.green,
                title: BlocBuilder<WorkoutDetailViewBloc, WorkoutDetailViewState>(
                  buildWhen: (p, c) => p.workout.note != c.workout.note,
                  builder: (context, state) {
                    return Text(state.workout.note);
                  },
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: state.appBarLinearGradient,
                    borderRadius: state.appBarBorderRadius,
                  ),
                  child: FlexibleSpaceBar(
                    background: WorkoutInfoRow(),
                  ),
                ),
                expandedHeight: 200,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ListTile(
                      tileColor: Colors.red.shade100,
                    );
                  },
                  childCount: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
