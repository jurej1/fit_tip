import 'package:flutter/material.dart';

class BlogSearchView extends StatelessWidget {
  const BlogSearchView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return BlogSearchView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, enabled) {
          return [];
        },
        body: ListView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container();
            },
            childCount: 10,
          ),
        ),
      ),
    );
  }
}
