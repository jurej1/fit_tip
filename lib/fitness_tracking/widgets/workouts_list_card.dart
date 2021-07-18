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
        return Material(
          color: state.backgroundColor,
          borderRadius: state.borderRadius,
          child: InkWell(
            borderRadius: state.borderRadius,
            onTap: () {
              //GO to detail page
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Text(state.workout.note),
                  Spacer(),
                  const _OptionsButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OptionsButton extends StatelessWidget {
  const _OptionsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<WorkoutsListCardOptions>(
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
    );
  }
}

class _ExpandableIconButton extends StatelessWidget {
  const _ExpandableIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
