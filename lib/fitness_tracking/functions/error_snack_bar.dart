import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, Key key, {String? text}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        key: key,
        content: Text(text ?? 'Invalid'),
        backgroundColor: Colors.red,
      ),
    );
}
