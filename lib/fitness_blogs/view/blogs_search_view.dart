import 'package:flutter/material.dart';

import '../fitness_blogs.dart';

class BlogsSearchView extends StatelessWidget {
  static MaterialPageRoute<T> route<T>(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return BlogsSearchView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
    );
  }
}
