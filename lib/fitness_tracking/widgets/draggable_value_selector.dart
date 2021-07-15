import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../fitness_tracking.dart';

class DraggableValueSelector extends HookWidget {
  const DraggableValueSelector._({
    Key? key,
    this.itemHeight = 30,
    this.backgroundColor,
    required this.itemCount,
  }) : super(key: key);

  static Widget route({required double itemHeight, Color? backgroundColor, required int itemCount}) {
    return BlocProvider(
      create: (context) => DraggableValueSelectorBloc(),
      child: DraggableValueSelector._(
        itemHeight: itemHeight,
        backgroundColor: backgroundColor,
        itemCount: itemCount,
      ),
    );
  }

  final double itemHeight;
  final Color? backgroundColor;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final _controller = useScrollController();

    return BlocConsumer<DraggableValueSelectorBloc, DraggableValueSelectorState>(
      listener: (context, state) {
        if (state.listState == DraggableValueSelectorListState.stop) {
          _controller.animateTo(
            state.getAnimateToValue(itemHeight),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutQuad,
          );

          BlocProvider.of<DraggableValueSelectorBloc>(context).add(DraggableValueSelectorListSnapped());
        }
      },
      builder: (context, state) {
        final listHeight = state.amountOfVisibibleItems * itemHeight;
        return Container(
          color: backgroundColor,
          height: listHeight,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                BlocProvider.of<DraggableValueSelectorBloc>(context).add(DraggableValueSelectorScrollUpdate(_controller, itemHeight));
              }

              if (notification is ScrollEndNotification) {
                BlocProvider.of<DraggableValueSelectorBloc>(context).add(DraggableValueSelectorScrollEnd(_controller, itemHeight));
              }

              return true;
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: (listHeight - itemHeight) * 0.5),
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemExtent: itemHeight,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return AnimatedDefaultTextStyle(
                  child: Text('$index'),
                  style: TextStyle(
                    fontSize: state.getTextSize(index, itemHeight),
                    height: 1,
                    color: state.getTextColor(index),
                  ),
                  duration: const Duration(milliseconds: 300),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
