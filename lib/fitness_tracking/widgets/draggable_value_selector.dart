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
    required this.onValueUpdated,
    required this.width,
  }) : super(key: key);

  static Widget route({
    Key? key,
    required double itemHeight,
    Color? backgroundColor,
    required void Function(int) onValueUpdated,
    required int itemCount,
    required double width,
  }) {
    return BlocProvider(
      create: (context) => DraggableValueSelectorBloc(),
      child: DraggableValueSelector._(
        key: key,
        itemHeight: itemHeight,
        backgroundColor: backgroundColor,
        itemCount: itemCount,
        onValueUpdated: onValueUpdated,
        width: width,
      ),
    );
  }

  final double itemHeight;
  final Color? backgroundColor;
  final int itemCount;
  final void Function(int) onValueUpdated;
  final double width;

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
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          width: itemHeight * 1.5,
          height: listHeight,
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
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
                      textAlign: TextAlign.center,
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
            ],
          ),
        );
      },
    );
  }
}
