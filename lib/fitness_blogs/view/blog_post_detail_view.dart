import 'package:blog_repository/blog_repository.dart';
import 'package:flutter/material.dart';

class BlogPostDetailView extends StatelessWidget {
  const BlogPostDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(
    BuildContext context,
    BlogPost blogPost,
  ) {
    return MaterialPageRoute(
      builder: (_) {
        return BlogPostDetailView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog post detail view'),
      ),
    );
  }
}
