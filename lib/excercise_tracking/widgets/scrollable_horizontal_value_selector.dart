import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollableHorizontalValueSelector extends StatelessWidget {
  const ScrollableHorizontalValueSelector({
    Key? key,
    required this.onValueUpdated,
    this.initialIndex,
    required this.width,
    required this.itemsLength,
    required this.mode,
  }) : super(key: key);

  final int? initialIndex;
  final void Function(int value) onValueUpdated;
  final double width;
  final int itemsLength;
  final DurationSelectorValueMode mode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DurationSelectorBloc(
        initialIndex: initialIndex,
        itemsLength: itemsLength,
        mode: mode,
      ),
      child: _Body(
        width: width,
        onValueUpdated: onValueUpdated,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key? key,
    required this.onValueUpdated,
    required this.width,
  }) : super(key: key);
  final void Function(int value) onValueUpdated;
  final double width;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  late final ScrollController _scrollController;

  final double itemWidth = 25;
  final double columnHeight = 140;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: BlocProvider.of<DurationSelectorBloc>(context).state.getAnimateToValue(itemWidth),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return BlocConsumer<DurationSelectorBloc, DurationSelectorState>(
      listener: (context, state) {
        widget.onValueUpdated(state.focusedIndex);

        if (state.status == DurationSelectorStatus.scrollEnded) {
          _scrollController.animateTo(
            state.getAnimateToValue(itemWidth),
            duration: state.animationDuration,
            curve: Curves.fastOutSlowIn,
          );
          BlocProvider.of<DurationSelectorBloc>(context).add(DurationSelectorListSnapped());
        }
      },
      builder: (context, state) {
        return Container(
          width: widget.width,
          height: columnHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _TextDisplayer(),
              const SizedBox(height: 7),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      BlocProvider.of<DurationSelectorBloc>(context).add(
                        DurationSelectorScrollUpdated(
                          controller: _scrollController,
                          itemWidth: itemWidth,
                        ),
                      );
                    } else if (scrollNotification is ScrollEndNotification) {
                      BlocProvider.of<DurationSelectorBloc>(context).add(
                        DurationSelectorScrollEnd(
                          controller: _scrollController,
                          itemWidth: itemWidth,
                        ),
                      );
                    }

                    return false;
                  },
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.width * 0.5 - (itemWidth * 0.5),
                    ),
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: state.animationDuration,
                        width: itemWidth,
                        padding: EdgeInsets.symmetric(
                          horizontal: state.horizontalPadding(index, itemWidth),
                          vertical: state.verticalPadding(index, itemWidth),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: state.animationDuration,
                            color: state.backgroundColor(index),
                          ),
                        ),
                      );
                    },
                    itemCount: state.itemsLength,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TextDisplayer extends StatelessWidget {
  const _TextDisplayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DurationSelectorBloc, DurationSelectorState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: state.animationDuration,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: state.status == DurationSelectorStatus.scrolling ? Colors.blue.shade100 : Colors.grey.shade200,
          ),
          child: Text(
            state.mode == DurationSelectorValueMode.minutes ? state.mapIndexToText() : state.focusedIndex.toStringAsFixed(0),
          ),
        );
      },
    );
  }
}
