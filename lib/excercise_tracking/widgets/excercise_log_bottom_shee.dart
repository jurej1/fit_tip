import 'package:flutter/material.dart';

class ExcerciseLogBottomSheet extends StatelessWidget {
  const ExcerciseLogBottomSheet({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 5,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade400,
          ),
        ),
        ListView.builder(
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        ),
      ],
    );
  }
}
