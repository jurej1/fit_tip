import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';

import '../fitness_tracking.dart';

class WorkoutsList extends StatefulWidget {
  WorkoutsList({
    Key? key,
    required this.hasReachedMax,
    required this.workouts,
    required this.onBottom,
  }) : super(key: key);

  final bool hasReachedMax;
  final List<WorkoutInfoRaw> workouts;
  final VoidCallback onBottom;

  @override
  _WorkoutsListState createState() => _WorkoutsListState();
}

class _WorkoutsListState extends State<WorkoutsList> {
  late final ScrollController _scrollController;
  final int _loaderSpace = 200;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: widget.hasReachedMax ? widget.workouts.length : widget.workouts.length + 1,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        if (index >= widget.workouts.length) {
          return Container(
            height: 30,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }
        final item = widget.workouts[index];
        return WorkoutInfoListCard.route(context, item); //TODO workout
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }

  void _listener() {
    if (_isBottom) {
      widget.onBottom();
    }
  }

  bool get _isBottom {
    double offset = _scrollController.offset;
    double maxScroll = _scrollController.position.maxScrollExtent;

    return (offset + _loaderSpace) >= maxScroll;
  }
}
