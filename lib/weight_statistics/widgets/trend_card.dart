import 'package:flutter/material.dart';

class TrendCard extends StatelessWidget {
  final double? number;
  final String text;

  const TrendCard({
    Key? key,
    this.number,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Text(
            number == null ? '-' : number.toString(),
          ),
        ],
      ),
    );
  }
}
