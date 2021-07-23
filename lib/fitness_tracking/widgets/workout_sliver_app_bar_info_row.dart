import 'package:flutter/material.dart';

class WorkoutInfoRow extends StatelessWidget {
  const WorkoutInfoRow({
    Key? key,
    required this.created,
    required this.daysPerWeek,
    required this.goal,
  }) : super(key: key);

  final String created;
  final String daysPerWeek;
  final String goal;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Align(
        alignment: Alignment(0, 0.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RowItem(title: 'Created', text: created, icon: const Icon(Icons.calendar_today)),
              _RowItem(title: 'Days per week', text: daysPerWeek, icon: const Icon(Icons.sports)),
              _RowItem(title: 'Goal', text: goal, icon: const Icon(Icons.pin_drop)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    Key? key,
    required this.title,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(text),
        ],
      ),
    );
  }
}
