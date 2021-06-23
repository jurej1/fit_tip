import 'package:flutter/material.dart';

class RowInputField extends StatelessWidget {
  const RowInputField({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    required this.unit,
    required this.title,
    this.errorText,
  }) : super(key: key);

  final String initialValue;
  final Function(String) onChanged;
  final String unit;
  final String title;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        Expanded(
          child: TextFormField(
            key: key,
            initialValue: initialValue,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              errorText: errorText,
              border: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        ),
        Text(unit),
      ],
    );
  }
}
