import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutsListCard extends StatelessWidget {
  const WorkoutsListCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutsListCardBloc, WorkoutsListCardState>(
      builder: (context, state) {
        return Container(
          child: ListTile(
            title: Text(state.workout.note),
            trailing: PopupMenuButton<WorkoutsListCardOptions>(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return WorkoutsListCardOptions.values.map((e) {
                  return PopupMenuItem(
                    child: Text(
                      describeEnum(e),
                    ),
                    value: e,
                  );
                }).toList();
              },
              onSelected: (option) {
                if (option == WorkoutsListCardOptions.delete) {
                  //TODO
                } else if (option == WorkoutsListCardOptions.edit) {
                  //TODO
                } else if (option == WorkoutsListCardOptions.setAsActive) {
                  //TODO
                }
              },
            ),
          ),
        );
      },
    );
  }
}
