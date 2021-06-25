import 'dart:math';

import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowExpandedInputListTile extends StatefulWidget {
  const ShowExpandedInputListTile({
    Key? key,
  }) : super(key: key);

  @override
  _ShowExpandedInputListTileState createState() => _ShowExpandedInputListTileState();
}

class _ShowExpandedInputListTileState extends State<ShowExpandedInputListTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: pi,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddFoodItemBloc, AddFoodItemState>(
      listenWhen: (p, c) => p.showDetail != c.showDetail,
      listener: (context, state) {
        final status = _controller.status;
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
      },
      builder: (context, state) {
        return ListTile(
          title: Text('Show detail inputs'),
          dense: true,
          contentPadding: EdgeInsets.zero,
          trailing: IconButton(
            icon: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Transform.rotate(
                  angle: _controller.value,
                  child: const Icon(Icons.keyboard_arrow_up_rounded),
                );
              },
            ),
            onPressed: () {
              BlocProvider.of<AddFoodItemBloc>(context).add(AddFoodItemShowDetailPressed());
            },
          ),
        );
      },
    );
  }
}
