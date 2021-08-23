import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPostsView extends StatelessWidget {
  const BlogPostsView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => BlogPostsListBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
              ),
            )
          ],
          child: BlogPostsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs view'),
      ),
    );
  }
}
