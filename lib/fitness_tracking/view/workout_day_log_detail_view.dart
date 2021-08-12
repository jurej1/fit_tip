import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../fitness_tracking.dart';

class WorkoutDayLogDetailView extends StatelessWidget {
  const WorkoutDayLogDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(WorkoutDayLog log) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => WorkoutDayLogDetailBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            dayLog: log,
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
          ),
          child: const WorkoutDayLogDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutDayLogDetailBloc, WorkoutDayLogDetailState>(
      listener: (context, state) {
        if (state is WorkoutDayLogDetailDeleteSuccess) {
          //TODO update the list
          Navigator.of(context).pop();
        } else if (state is WorkoutDayLogDetailFail) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sorry there was an error')));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout details'),
          actions: [
            IconButton(
              onPressed: () {
                BlocProvider.of<WorkoutDayLogDetailBloc>(context).add(WorkoutDayLogDetailDeleteRequested());
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: BlocBuilder<WorkoutDayLogDetailBloc, WorkoutDayLogDetailState>(
          builder: (context, state) {
            if (state is WorkoutDayLogDetailLoading) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created on ${DateFormat('EEE, MMM d ' 'yy').format(state.dayLog.created)}',
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.dayLog.excercises.length,
                    itemBuilder: (context, index) {
                      final item = state.dayLog.excercises[index];
                      return WorkoutExcerciseCard.provider(item);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
