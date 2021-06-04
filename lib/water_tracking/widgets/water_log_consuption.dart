import 'dart:math';

import 'package:fit_tip/water_tracking/water_tracking.dart';
import 'package:fit_tip/water_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterLogConsumption extends StatefulWidget {
  @override
  _WaterLogConsumptionState createState() => _WaterLogConsumptionState();
}

class _WaterLogConsumptionState extends State<WaterLogConsumption> with SingleTickerProviderStateMixin {
  final double sizeA = 250;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
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
    return BlocBuilder<WaterLogConsumptionBloc, WaterLogConsumptionState>(
      builder: (context, state) {
        if (state is WaterLogConsumptionLoadSucccess) {
          _animationController.forward();
          return Container(
            height: sizeA,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                    painter: ProgressPainter(
                      primaryValue: _animationController.value * state.amount,
                      maxValue: state.max,
                    ),
                    child: child);
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${state.amount.toStringAsFixed(0)}ml',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Daily Goal: ${state.max.toStringAsFixed(0)}ml',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is WaterLogConsumptionLoading) {
          return Container(
            height: sizeA,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return Container();
      },
    );
  }
}
