import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../fitness_tracking.dart';

class RepUnitValueSelector extends StatefulWidget {
  const RepUnitValueSelector({
    Key? key,
    required this.onValueUpdated,
  }) : super(key: key);

  static Widget route({
    required double itemHeight,
    required double height,
    RepUnit? initialValue,
    required void Function(RepUnit) onValueUpdated,
  }) {
    return BlocProvider(
      create: (context) => RepUnitValueSelectorBloc(
        itemHeight: itemHeight,
        height: height,
      ),
      child: RepUnitValueSelector(onValueUpdated: onValueUpdated),
    );
  }

  final void Function(RepUnit) onValueUpdated;

  @override
  _RepUnitValueSelectorState createState() => _RepUnitValueSelectorState();
}

class _RepUnitValueSelectorState extends State<RepUnitValueSelector> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    final repUnitBloc = BlocProvider.of<RepUnitValueSelectorBloc>(context);
    _controller = ScrollController(
      initialScrollOffset: repUnitBloc.state.focusedValue != 0 ? repUnitBloc.state.getAnimateToValue() : 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          height: state.height,
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
              itemExtent: state.itemHeight,
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
