import 'package:flutter/material.dart';

ScaffoldMessengerState showErrorSnackBar(BuildContext context, Key key, {String? text}) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        key: key,
        content: Text(text ?? 'Invalid'),
        backgroundColor: Colors.red,
      ),
    );
}
