import 'dart:math';

import 'package:flutter/material.dart';

class ShakeAnimationBuilder extends StatelessWidget {
  const ShakeAnimationBuilder({
    Key? key,
    required AnimationController controller,
    required this.child,
  })  : this._controller = controller,
        super(key: key);

  final AnimationController _controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, status) {
        final y = 5 * sin(2.5 * _controller.value);

        return Transform.translate(
          offset: Offset(0, y),
          child: child,
        );
      },
      child: child,
    );
  }
}
