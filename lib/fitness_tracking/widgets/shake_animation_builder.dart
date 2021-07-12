import 'dart:math';

import 'package:flutter/material.dart';

class ShakeAnimationBuilder extends StatelessWidget {
  const ShakeAnimationBuilder({
    Key? key,
    required AnimationController controller,
    required this.child,
    this.shakeAxis = Axis.horizontal,
  })  : this._controller = controller,
        super(key: key);

  final AnimationController _controller;
  final Widget child;
  final Axis shakeAxis;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, status) {
        final value = 5 * sin(2.5 * _controller.value);

        return Transform.translate(
          offset: Offset(
            shakeAxis == Axis.horizontal ? value : 0,
            shakeAxis == Axis.vertical ? value : 0,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
