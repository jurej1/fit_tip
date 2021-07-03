import 'package:flutter/material.dart';

class TilePressedLineIndicator extends StatelessWidget {
  const TilePressedLineIndicator({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    required this.isExpanded,
    this.color = Colors.blue,
  }) : super(key: key);

  final Duration duration;
  final bool isExpanded;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      height: isExpanded ? 1.75 : 0,
      width: isExpanded ? MediaQuery.of(context).size.width * 0.8 : 0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isExpanded ? color : Colors.white,
      ),
    );
  }
}
