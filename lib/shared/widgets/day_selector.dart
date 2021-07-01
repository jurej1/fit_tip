import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySelector extends StatelessWidget {
  const DaySelector({
    Key? key,
    required this.arrowBackPressed,
    required this.arrowFowardPressed,
    required this.selectedDate,
    required this.firstDate,
    required this.dayChoosed,
  }) : super(key: key);

  final VoidCallback arrowBackPressed;
  final VoidCallback arrowFowardPressed;
  final DateTime selectedDate;
  final DateTime firstDate;
  final Function(DateTime?) dayChoosed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: arrowBackPressed,
        ),
        TextButton(
          child: Text(DateFormat('d.MMMM.yyyy').format(selectedDate)),
          onPressed: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: firstDate,
              lastDate: DateTime.now(),
            );

            dayChoosed(date);
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          onPressed: arrowFowardPressed,
        ),
      ],
    );
  }
}
