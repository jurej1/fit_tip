import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final Function(String) onChanged;
  final String? errorText;
  final Icon? preffixIcon;
  final Icon? suffixIcon;
  final String helperText;
  final FocusNode? focusNode;
  final bool obscure;
  final TextInputAction? action;

  const InputField({
    Key? key,
    required this.onChanged,
    this.errorText,
    this.preffixIcon,
    this.suffixIcon,
    required this.helperText,
    this.focusNode,
    this.action,
    this.obscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: action,
      autocorrect: false,
      focusNode: focusNode,
      decoration: InputDecoration(
        helperText: helperText,
        prefixIcon: preffixIcon,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscure,
      onChanged: onChanged,
    );
  }
}
