import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final Function(String) onChanged;
  final String? errorText;
  final Icon? preffixIcon;
  final Icon? suffixIcon;
  final String hintText;
  final FocusNode? focusNode;
  final bool obscure;
  final TextInputAction? action;
  final TextInputType? keyboardType;

  const InputField({
    Key? key,
    required this.onChanged,
    this.errorText,
    this.preffixIcon,
    this.suffixIcon,
    required this.hintText,
    this.focusNode,
    this.action,
    this.keyboardType,
    this.obscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: action,
      autocorrect: false,
      keyboardType: keyboardType,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: preffixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
      obscureText: obscure,
      onChanged: onChanged,
    );
  }
}
