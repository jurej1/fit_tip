import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DurationSelector extends StatelessWidget {
  const DurationSelector({
    Key? key,
    this.duration,
  }) : super(key: key);

  final int? duration;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DurationSelectorBloc(duration: duration),
      child: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  late final ScrollController _scrollController;

  final double itemWidth = 30;

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
    final Size size = MediaQuery.of(context).size;

    return BlocListener<DurationSelectorBloc, DurationSelectorState>(
      listener: (context, state) {
        _scrollController.animateTo(
          state.getAnimateToValue(itemWidth),
          duration: const Duration(milliseconds: 350),
          curve: Curves.fastOutSlowIn,
        );

        BlocProvider.of<AddExcerciseLogBloc>(context).add(
          AddExcerciseLogDurationUpdated(
            state.mapIndexToMinutes(),
          ),
        );
      },
      child: Container(
        width: size.width,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<DurationSelectorBloc, DurationSelectorState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Text('${state.mapIndexToMinutes()} min'),
                );
              },
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  BlocProvider.of<DurationSelectorBloc>(context).add(
                    DurationSelectorValueUpdated(
                      controller: _scrollController,
                      itemWidth: itemWidth,
                    ),
                  );
                }

                return false;
              }, child: BlocBuilder<DurationSelectorBloc, DurationSelectorState>(
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (index == 0 || index == 289) {
                        return Container(
                          width: size.width * 0.5 - (itemWidth * 0.5),
                        );
                      }
                      return Container(
                        height: 200,
                        width: itemWidth,
                        padding: EdgeInsets.symmetric(horizontal: itemWidth * 0.25),
                        child: ColoredBox(
                          color: Colors.blue,
                        ),
                      );
                    },
                    itemCount: 288 + 2,
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
