import 'package:flutter/material.dart';

class SelectedViewDisplayer extends StatelessWidget {
  SelectedViewDisplayer({
    Key? key,
    required this.dotSize,
    required this.length,
    required this.controller,
    required this.selectedColor,
    Color? unselectedColor,
    this.width = 80,
  })  : this._height = dotSize + 5,
        this.unselectedColor = unselectedColor ?? Colors.grey.shade300,
        super(key: key);

  final double dotSize;
  final int length;
  final AnimationController controller;
  final Color selectedColor;
  final Color unselectedColor;

  final double width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              length,
              (index) {
                return Container(
                  height: dotSize,
                  width: dotSize,
                  decoration: BoxDecoration(
                    color: unselectedColor,
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return Positioned(
                left: getConstMultiplier() * controller.value,
                child: AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 250),
                  height: dotSize,
                  width: dotSize,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  double getConstMultiplier() {
    double a = dotSize * length;

    double b = width - a;

    return b / (length - 1);
  }
}
