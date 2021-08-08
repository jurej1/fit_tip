import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetDisplayer extends StatelessWidget {
  const SetDisplayer({
    Key? key,
  }) : super(key: key);

  static Widget provider(int setIndex) {
    return BlocProvider(
      create: (context) => SetDisplayerCubit(setIndex: setIndex),
      child: SetDisplayer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double containerSize = 120;

    return BlocListener<SetDisplayerCubit, SetDisplayerState>(
      listener: (context, state) {
        BlocProvider.of<ExcercisePageCardBloc>(context).add(ExcercisePageRepCountUpdated(value: state.repAmount, setIndex: state.setIndex));
        BlocProvider.of<ExcercisePageCardBloc>(context)
            .add(ExcercisePageWeightCountUpdated(value: state.weightAmount, setIndex: state.setIndex));
      },
      child: Row(
        children: [
          Container(
            height: containerSize,
            width: size.width * 0.5,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black),
              ),
            ),
            child: Column(
              children: [
                Text('Rep Count'),
                const SizedBox(height: 8),
                Expanded(
                  child: BlocBuilder<SetDisplayerCubit, SetDisplayerState>(
                    builder: (context, state) {
                      return ScrollableHorizontalValueSelector(
                        onValueUpdated: (value) {
                          BlocProvider.of<SetDisplayerCubit>(context).repAmountUpdated(value);
                        },
                        width: size.width * 0.5,
                        initialIndex: state.repAmount,
                        itemsLength: 40,
                        textBuilder: (value) {
                          return Text('$value x');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: containerSize,
            width: size.width * 0.5,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.black),
              ),
            ),
            child: Column(
              children: [
                Text('Weight'),
                const SizedBox(height: 8),
                Expanded(
                  child: BlocBuilder<SetDisplayerCubit, SetDisplayerState>(
                    builder: (context, state) {
                      return ScrollableHorizontalValueSelector(
                        onValueUpdated: (value) {
                          BlocProvider.of<SetDisplayerCubit>(context).weightAmountUpdated(value.toDouble());
                        },
                        width: size.width * 0.5,
                        initialIndex: state.weightAmount.toInt(),
                        itemsLength: 300,
                        textBuilder: (value) {
                          return Text('$value kg');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
