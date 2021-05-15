import 'package:flutter/material.dart';

class GoalRow extends StatelessWidget {
  final String text;
  final String value;
  final TextStyle? valueStyle;

  const GoalRow({
    Key? key,
    required this.text,
    required this.value,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: valueStyle,
        ),
      ],
    );
  }
}
