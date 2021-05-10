import 'package:flutter/material.dart';

class GoalRow extends StatelessWidget {
  final String text;
  final String value;

  const GoalRow({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        Text(value),
      ],
    );
  }
}
