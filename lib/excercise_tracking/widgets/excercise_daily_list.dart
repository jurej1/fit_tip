import 'package:activity_repository/activity_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExcerciseDailyList extends StatelessWidget {
  const ExcerciseDailyList({
    Key? key,
    this.excercises = const [],
  })  : this._length = excercises.length,
        super(key: key);

  final List<ExcerciseLog> excercises;
  final int _length;

  @override
  Widget build(BuildContext context) {
    if (_length == 0) {
      return Center(
        child: Text('You do not have any excercises.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _length,
      itemBuilder: (context, index) {
        final item = excercises[index];

        return ExpansionTile(
          key: ValueKey(item),
          title: Text(item.name),
          subtitle: Text(
            DateFormat('HH:mm').format(item.startTime),
            style: TextStyle(color: Colors.grey.shade400),
          ),
        );
      },
    );
  }
}
