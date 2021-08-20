import 'package:flutter/material.dart';

class CompleteAccountView extends StatelessWidget {
  const CompleteAccountView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (context) {
        return CompleteAccountView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete account view'),
      ),
    );
  }
}
