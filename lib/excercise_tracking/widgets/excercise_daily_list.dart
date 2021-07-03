import 'package:activity_repository/activity_repository.dart';
import 'package:flutter/material.dart';

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
    return ListView.builder(
      itemCount: _length,
      itemBuilder: (context, index) {
        final item = excercises[index];

        return ListTile(
          title: Text(item.name),
        );
      },
    );
  }
}
