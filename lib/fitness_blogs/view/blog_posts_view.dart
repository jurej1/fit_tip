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
        title: Text('Blogs view'),
      ),
      body: BlocBuilder<BlogPostsListBloc, BlogPostsListState>(
        builder: (context, state) {
          if (state is BlogPostsListLoading) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else if (state is BlogPostsListLoadSuccess) {
            final length = state.hasReachedMax ? state.blogs.length : state.blogs.length + 1;
            return ListView.separated(
              itemCount: length,
              itemBuilder: (context, index) {
                if (length - 1 == index && !state.hasReachedMax) {
                  return Container(
                    height: 50,
                    width: size.width,
                    child: const Center(
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }

                final item = state.blogs[index];
                return ListTile(
                  title: Text(item.title),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
