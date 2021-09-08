import 'package:authentication_repository/authentication_repository.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class UserBlogPostsView extends StatelessWidget {
  const UserBlogPostsView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, User user) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserBlogPostsBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                userId: user.id,
              )..add(BlogPostsLoadRequested()),
            )
          ],
          child: UserBlogPostsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User blog posts view'),
      ),
    );
  }
}
