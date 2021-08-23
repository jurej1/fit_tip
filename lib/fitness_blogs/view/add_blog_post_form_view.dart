import 'package:flutter/material.dart';

class AddBlogPostFormView extends StatelessWidget {
  const AddBlogPostFormView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return AddBlogPostFormView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
