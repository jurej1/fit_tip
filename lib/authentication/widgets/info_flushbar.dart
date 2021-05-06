import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showInfoAuthFlushbar(
  BuildContext context, {
  final String? title,
}) {
  if (title != null) {
    Flushbar(
      shouldIconPulse: true,
      message: title,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: BorderRadius.circular(10),
      icon: Icon(
        Icons.info_outline,
        color: Theme.of(context).primaryColor,
      ),
      margin: EdgeInsets.all(8),
    )..show(context);
  }
}
