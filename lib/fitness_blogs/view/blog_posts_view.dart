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
              )..add(BlogPostsListLoadRequested()),
            )
          ],
          child: BlogPostsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs view'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(AddBlogPostFormView.route(context));
            },
          ),
        ],
      ),
      body: BlocBuilder<BlogPostsListBloc, BlogPostsListState>(
        builder: (context, state) {
          if (state is BlogPostsListLoading) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else if (state is BlogPostsListLoadSuccess) {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: BlogPostsListBuilder(
                blogs: state.blogs,
                hasReachedMax: state.hasReachedMax,
              ),
            );
          } else if (state is BlogPostsListFail) {
            return Center(
              child: const Text('Sorry. There was an error.'),
            );
          }
          return Container();
        },
      ),
    );
  }
}
