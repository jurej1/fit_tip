import 'package:flutter/material.dart';

import 'package:fit_tip/water_tracking/water_tracking.dart';

class AnimatedProgressBar extends StatefulWidget {
  const AnimatedProgressBar({
    Key? key,
    required this.primaryValue,
    required this.maxValue,
    required this.primaryColor,
    required this.secondaryColor,
    this.child,
  }) : super(key: key);

  final double primaryValue;
  final double maxValue;
  final Color primaryColor;
  final Color secondaryColor;
  final Widget? child;

  @override
  __AnimatedProgressBarState createState() => __AnimatedProgressBarState();
}

class __AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.reset();
    _animationController.forward();

    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (context, child) {
        return CustomPaint(
          painter: ProgressPainter(
            innerColor: widget.primaryColor,
            outerColor: widget.secondaryColor,
            maxValue: widget.maxValue,
            primaryValue: _animationController.value * widget.primaryValue,
          ),
          child: child,
        );
      },
    );
  }
}
