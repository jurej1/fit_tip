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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          width: size.width,
          height: 100,
          color: Colors.red.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 50,
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
                    itemCount: 21,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        height: itemHeight,
                        child: Text(
                          '$index',
                          style: TextStyle(
                            fontSize: state.getTextSize(index, itemHeight),
                            height: 1,
                            color: state.getTextColor(index),
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
