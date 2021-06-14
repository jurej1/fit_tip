import 'package:flutter/material.dart';

class FoodItemDetailInputField extends StatelessWidget {
  const FoodItemDetailInputField({
    Key? key,
    this.labelText = '',
    required this.onChanged,
    this.isInvalid = false,
    this.errorText,
  }) : super(key: key);

  final String labelText;
  final Function(String) onChanged;
  final String? errorText;
  final bool isInvalid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(labelText),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: InputBorder.none,
              errorText: isInvalid ? errorText : null,
            ),
            onChanged: onChanged,
          ),
        ),
        Text(' g'),
      ],
    );
  }
}
