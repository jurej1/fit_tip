import 'package:flutter/material.dart';

class WeightHistoryView extends StatelessWidget {
  static const routeName = 'weight_history_view';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Container(
                height: 50,
                width: size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
