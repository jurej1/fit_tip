import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, {String? text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text ?? 'Invalid'),
      backgroundColor: Colors.red,
    ),
  );
}
