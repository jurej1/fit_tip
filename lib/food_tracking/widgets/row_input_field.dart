import 'package:flutter/material.dart';

class RowInputField extends StatelessWidget {
  const RowInputField({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    required this.unit,
    required this.title,
    required this.keyboardType,
    this.textDirection = TextDirection.rtl,
    this.errorText,
  }) : super(key: key);

  final String initialValue;
  final Function(String) onChanged;
  final String unit;
  final String title;
  final String? errorText;
  final TextInputType keyboardType;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        Expanded(
          child: TextFormField(
            textDirection: TextDirection.rtl,
            key: key,
            initialValue: initialValue,
            textAlign: TextAlign.right,
            keyboardType: keyboardType,
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
