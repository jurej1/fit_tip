import 'package:flutter/material.dart';

class SwitchViewButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SwitchViewButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }
}
