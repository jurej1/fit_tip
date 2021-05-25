import 'package:flutter/material.dart';

class WaterLogGridTileDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.green,
            child: Text('Hello'),
          ),
        ],
      ),
    );
  }
}
