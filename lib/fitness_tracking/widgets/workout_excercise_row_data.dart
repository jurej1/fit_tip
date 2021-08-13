import 'package:flutter/material.dart';

class WorkoutExcerciseRowData extends StatelessWidget {
  const WorkoutExcerciseRowData({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
