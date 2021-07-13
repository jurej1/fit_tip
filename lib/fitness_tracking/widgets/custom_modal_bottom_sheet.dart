import 'package:flutter/material.dart';

Future showCustomModalBottomSheet<T>(BuildContext context, {required Widget child}) {
  final Size size = MediaQuery.of(context).size;
  return showModalBottomSheet<T>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return Column(
        children: [
          const SizedBox(height: 15),
          Container(
            height: 7,
            width: size.width * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      );
    },
  );
}
