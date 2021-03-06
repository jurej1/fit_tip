import 'package:flutter/material.dart';

class FoodItemDetailInputField extends StatelessWidget {
  const FoodItemDetailInputField({
    Key? key,
    this.labelText = '',
    required this.onChanged,
    this.isInvalid = false,
    this.errorText,
    this.keyboardType = TextInputType.number,
    this.initialValue,
  }) : super(key: key);

  final String labelText;
  final Function(String) onChanged;
  final String? errorText;
  final bool isInvalid;
  final TextInputType? keyboardType;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(labelText),
        Expanded(
          child: TextFormField(
            keyboardType: keyboardType,
            initialValue: initialValue,
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
