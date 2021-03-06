import 'dart:math';

import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WorkoutInfoListCard extends StatelessWidget {
  const WorkoutInfoListCard({Key? key}) : super(key: key);

  static Widget provider(BuildContext context, WorkoutInfoRaw item) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey(item),
          create: (context) => WorkoutsListCardBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
            info: item,
          ),
        ),
        if (item is WorkoutInfo)
          BlocProvider(
            create: (context) => WorkoutLikeCubit(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
              workoutId: item.id,
              like: item.like,
            ),
          ),
        if (item is WorkoutInfo)
          BlocProvider(
            create: (context) => WorkoutSaveCubit(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
              isSaved: item.isSaved,
              workoutId: item.id,
            ),
          )
      ],
      child: WorkoutInfoListCard(
        key: ValueKey(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutsListCardBloc, WorkoutsListCardState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: state.borderRadius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: state.backgroundColor,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (state.info.isWorkoutInfo) {
                    Navigator.of(context).push(WorkoutDetailView.route(context, info: state.info as WorkoutInfo));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.info.title,
                              maxLines: 3,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          const _OptionsButton(),
                          const _ExpandableIconButton(),
                        ],
                      ),
                      const _DataContainer(),
                      const _BottomActions(),
                    ],
                  ),
                ),
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
    return BlocBuilder<WorkoutsListCardBloc, WorkoutsListCardState>(
      builder: (context, state) {
        if (state is WorkoutsListCardLoading) {
          return const SizedBox(
            height: 30,
            width: 30,
            child: const CircularProgressIndicator(),
          );
        }

        return PopupMenuButton<WorkoutsListCardOption>(
          icon: const Icon(Icons.more_vert),
          iconSize: BlocProvider.of<WorkoutsListCardBloc>(context).state.iconSize,
          itemBuilder: (context) {
            return WorkoutsListCardOption.values.map((e) {
              return PopupMenuItem(
                child: Text(e.toStringReadable()),
                value: e,
              );
            }).toList();
          },
          onSelected: (option) {
            if (option.isSetAsActive) {
              BlocProvider.of<WorkoutsListCardBloc>(context).add(WorkoutsListCardSetAsActiveRequested());
            }
          },
        );
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
            iconSize: state.iconSize,
            onPressed: () {
              BlocProvider.of<WorkoutsListCardBloc>(context).add(WorkoutsListCardExpandedButtonPressed());
            },
          ),
        );
      },
    );
  }
}

class _DataContainer extends StatelessWidget {
  const _DataContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutsListCardBloc, WorkoutsListCardState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: state.isExpanded ? 75 : 0,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(state.info.mapDaysPerWeekToText),
              if (state.info.goal != null) Text('Goal: ${state.info.goal!.toStringReadable()}'),
              if (state.info.type != null) Text('Type: ${state.info.type!.toStringReadable()}'),
            ],
          ),
        );
      },
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutsListCardBloc, WorkoutsListCardState>(
      builder: (context, state) {
        return Visibility(
          visible: state.info is WorkoutInfo,
          child: Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<WorkoutLikeCubit, WorkoutLikeState>(
                  builder: (context, state) {
                    return InkResponse(
                      radius: 20,
                      onTap: () {
                        BlocProvider.of<WorkoutLikeCubit>(context).like();
                      },
                      child: Icon(state.like.isUp ? Icons.favorite : Icons.favorite_outline),
                    );
                  },
                ),
                BlocBuilder<WorkoutSaveCubit, WorkoutSaveState>(
                  builder: (context, state) {
                    return InkResponse(
                      radius: 20,
                      onTap: () {
                        BlocProvider.of<WorkoutSaveCubit>(context).save();
                      },
                      child: Icon(state.isSaved ? Icons.bookmark : Icons.bookmark_outline),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
