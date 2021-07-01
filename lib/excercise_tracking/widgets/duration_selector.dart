import 'package:fit_tip/excercise_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DurationSelector extends StatefulWidget {
  const DurationSelector({Key? key}) : super(key: key);

  @override
  _DurationSelectorState createState() => _DurationSelectorState();
}

class _DurationSelectorState extends State<DurationSelector> {
  late final ScrollController _scrollController;

  final double itemWidth = 30;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocListener<AddExcerciseLogBloc, AddExcerciseLogState>(
      listener: (context, state) {
        _scrollController.animateTo(
          state.getAnimateToValue(itemWidth),
          duration: const Duration(milliseconds: 350),
          curve: Curves.fastOutSlowIn,
        );
      },
      child: Container(
        width: size.width,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<AddExcerciseLogBloc, AddExcerciseLogState>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Text('${state.mapIndexToMinutes()} min'),
                );
              },
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    BlocProvider.of<AddExcerciseLogBloc>(context).add(
                      AddExcerciseLogDurationUpdated(
                        controller: _scrollController,
                        itemWidth: itemWidth,
                        screenWidth: size.width,
                      ),
                    );
                  }

                  return false;
                },
                child: ListView.builder(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
