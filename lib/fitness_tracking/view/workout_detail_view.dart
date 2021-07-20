import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class WorkoutInfoRow extends StatelessWidget {
  const WorkoutInfoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<WorkoutDetailViewBloc, WorkoutDetailViewState>(
      builder: (context, state) {
        return Container(
          width: size.width,
          child: Align(
            alignment: Alignment(0, 0.5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        const SizedBox(height: 5),
                        Text('Created'),
                        const SizedBox(height: 5),
                        Text(state.workout.mapCreatedToState),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        const SizedBox(height: 5),
                        Text('Days Per Week'),
                        const SizedBox(height: 5),
                        Text(state.workout.daysPerWeek.toStringAsFixed(0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        const SizedBox(height: 5),
                        Text('Created'),
                        const SizedBox(height: 5),
                        Text(state.workout.mapCreatedToState),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
