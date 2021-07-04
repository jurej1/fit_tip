import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../excercise_tracking.dart';

class ExcerciseTile extends StatelessWidget {
  const ExcerciseTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcerciseTileBloc, ExcerciseTileState>(
      builder: (context, state) {
        return AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: state.isExpanded ? 110 : 50,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              _Tile(height: 40),
              _AnimatedDetailsList(height: state.isExpanded ? 60 : 0),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedDetailsList extends StatelessWidget {
  const _AnimatedDetailsList({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcerciseTileBloc, ExcerciseTileState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RowDisplayer(
                        firstTitle: 'Duration: ',
                        firstValue: '${state.excerciseLog.duration}min',
                        secondTitle: 'Type: ',
                        secondValue: describeEnum(state.excerciseLog.type),
                      ),
                    ),
                    Expanded(
                      child: RowDisplayer(
                        firstTitle: 'Intensity: ',
                        firstValue: describeEnum(state.excerciseLog.intensity),
                        secondTitle: 'Calories: ',
                        secondValue: state.excerciseLog.calories.toString(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcerciseTileBloc, ExcerciseTileState>(
      builder: (context, state) {
        return Container(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.excerciseLog.name),
                  Text(
                    DateFormat('HH:mm').format(state.excerciseLog.startTime),
                  )
                ],
              ),
              _AnimatedIconArrow(),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedIconArrow extends StatefulWidget {
  const _AnimatedIconArrow({Key? key}) : super(key: key);

  @override
  __AnimatedIconArrowState createState() => __AnimatedIconArrowState();
}

class __AnimatedIconArrowState extends State<_AnimatedIconArrow> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0,
      upperBound: pi,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ExcerciseTileBloc>(context).add(ExcerciseTilePressed());
      },
      child: BlocListener<ExcerciseTileBloc, ExcerciseTileState>(
        listenWhen: (p, c) => p.isExpanded != c.isExpanded,
        listener: (context, state) {
          if (state.isExpanded) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value,
              child: child,
            );
          },
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}

class RowDisplayer extends StatelessWidget {
  const RowDisplayer({
    Key? key,
    required this.firstTitle,
    required this.firstValue,
    required this.secondValue,
    required this.secondTitle,
  }) : super(key: key);

  final String firstTitle;
  final String firstValue;
  final String secondValue;
  final String secondTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              _titleText(firstTitle),
              _childText(firstValue),
            ],
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 5),
        RichText(
          text: TextSpan(
            children: [
              _titleText(secondTitle),
              _childText(secondValue),
            ],
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  TextSpan _titleText(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  TextSpan _childText(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
          // color: Colors.grey.shade400,
          ),
    );
  }
}
