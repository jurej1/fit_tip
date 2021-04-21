import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showInfoAuthFlushbar(
  BuildContext context, {
  required final String title,
}) {
  Flushbar(
    shouldIconPulse: true,
    title: title,
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
