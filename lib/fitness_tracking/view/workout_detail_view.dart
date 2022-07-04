import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, {required WorkoutInfo info}) {
    final workoutsListBloc = BlocProvider.of<WorkoutInfosListBloc>(context);

    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => WorkoutDetailViewBloc(
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
                info: info,
              )..add(WorkoutDetailViewDaysLoadRequested()),
            ),
            BlocProvider(
              create: (context) => WorkoutDeleteCubit(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
                workoutInfo: info,
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
    return BlocListener<WorkoutDeleteCubit, WorkoutDeleteState>(
      listener: (context, state) {
        if (state is WorkoutDeleteLoadSuccess) {
          BlocProvider.of<WorkoutInfosListBloc>(context).add(
            WorkoutInfosItemRemoved(
              BlocProvider.of<WorkoutDetailViewBloc>(context).state.workout.info,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is WorkoutDeleteFail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Delete fail'),
            ),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            WorkoutDetailAppBar(),
            BlocBuilder<WorkoutDetailViewBloc, WorkoutDetailViewState>(
              builder: (context, state) {
                if (state is WorkoutDetailViewLoading) {
                  return const SliverToBoxAdapter(
                    child: const LinearProgressIndicator(),
                  );
                }

                if (state is WorkoutDetailViewLoadSuccess) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          if (state.workout.info.note != null) ...{
                            Text(
                              'Info',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            Text(state.workout.info.note!),
                          },
                          if (state.workout.workoutDays != null) ...{
                            ...state.workout.workoutDays!.workoutDays.map(
                              (e) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: WorkoutDetailItem(workout: e),
                                );
                              },
                            ).toList(),
                          }
                        ],
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter();
              },
            ),
          ],
        ),
      ),
    );
  }
}
