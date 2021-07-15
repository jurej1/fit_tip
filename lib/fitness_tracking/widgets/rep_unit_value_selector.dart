import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../fitness_tracking.dart';

class RepUnitValueSelector extends HookWidget {
  const RepUnitValueSelector({Key? key}) : super(key: key);

  static Widget route({required double itemHeight}) {
    return BlocProvider(
      create: (context) => RepUnitValueSelectorBloc(
        itemHeight: itemHeight,
      ),
      child: RepUnitValueSelector(),
    );
  }

  final double itemHeight = 30;
  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = useScrollController();

    return BlocConsumer<RepUnitValueSelectorBloc, RepUnitValueSelectorState>(
      listener: (context, state) {
        if (state.listState == RepUnitValueSelectorListState.stop) {
          _controller.animateTo(
            state.getAnimateToValue(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastLinearToSlowEaseIn,
          );
          BlocProvider.of<RepUnitValueSelectorBloc>(context).add(RepUnitValueSelectorListSnapped());
        }
      },
      builder: (context, state) {
        return Container(
          height: state.listSize(),
          width: state.width(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                BlocProvider.of<RepUnitValueSelectorBloc>(context).add(RepUnitValueSelectorListScrollEnd(_controller));
              }
              if (notification is ScrollUpdateNotification) {
                BlocProvider.of<RepUnitValueSelectorBloc>(context).add(RepUnitValueSelectorListScrollUpdated(_controller));
              }

              return true;
            },
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              controller: _controller,
              padding: EdgeInsets.symmetric(vertical: state.getVerticalPadding()),
              itemCount: RepUnit.values.length,
              itemExtent: itemHeight,
              itemBuilder: (context, index) {
                final item = RepUnit.values[index];
                return AnimatedDefaultTextStyle(
                  child: Text(describeEnum(item)),
                  curve: Curves.easeInOut,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: state.getFontColor(index),
                    height: 1,
                    fontSize: state.getFontSize(index),
                  ),
                  duration: const Duration(milliseconds: 400),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
