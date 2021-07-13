import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddWorkoutExcerciseView extends StatelessWidget {
  const AddWorkoutExcerciseView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddWorkoutExcerciseFormBloc(),
            ),
          ],
          child: AddWorkoutExcerciseView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout Excercise View'),
      ),
      body: DraggableValueSelector.route(),
    );
  }
}

class DraggableValueSelector extends HookWidget {
  const DraggableValueSelector({Key? key}) : super(key: key);

  static Widget route() {
    return BlocProvider(
      create: (context) => DraggableValueSelectorBloc(),
      child: DraggableValueSelector(),
    );
  }

  final double itemHeight = 30;
  final double margin = 3;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _controller = useScrollController();

    return BlocConsumer<DraggableValueSelectorBloc, DraggableValueSelectorState>(
      listener: (context, state) {
        if (state.listState == DraggableValueSelectorListState.stop) {
          _controller.animateTo(
            state.getAnimateToValue(itemHeight, margin),
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastLinearToSlowEaseIn,
          );
        }
      },
      builder: (context, state) {
        return Container(
          width: size.width,
          height: 100,
          color: Colors.red.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.green,
                width: 50,
                height: itemHeight * state.amountOfVisibibleItems,
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
                    controller: _controller,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 21,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        child: ColoredBox(
                          color: Colors.blue,
                          child: Text(
                            '$index',
                            style: TextStyle(
                              fontSize: itemHeight,
                              height: 1.2,
                            ),
                          ),
                        ),
                      );
                    },
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
