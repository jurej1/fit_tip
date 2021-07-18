import 'dart:math';

import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
                  const _ExpandableIconButton(),
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

class _ExpandableIconButton extends HookWidget {
  const _ExpandableIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
      lowerBound: 0 + 1 / 2 * pi,
      upperBound: pi + 1 / 2 * pi,
    );
    return BlocConsumer<WorkoutsListCardBloc, WorkoutsListCardState>(
      listenWhen: (p, c) => p.isExpanded != c.isExpanded,
      listener: (context, state) {
        if (state.isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value,
              child: child,
            );
          },
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              BlocProvider.of<WorkoutsListCardBloc>(context).add(WorkoutsListCardExpandedButtonPressed());
            },
          ),
        );
      },
    );
  }
}
