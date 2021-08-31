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
            // view selector cubit
            BlocProvider(
              create: (context) => BlogsViewSelectorCubit(),
              child: Container(),
            ),
            BlocProvider(
              create: (context) => BlogPostsSearchFilterBloc(),
            ),
            //Hydrated blocs
            BlocProvider(
              create: (context) => SavedBlogPostsBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              ),
            ),
            BlocProvider(
              create: (context) => LikedBlogPostsBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              ),
            ),

            // Blog lists blocs
            BlocProvider(
              create: (context) => BlogPostsSavedListBloc(
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                blogPostsSearchFilterBloc: BlocProvider.of<BlogPostsSearchFilterBloc>(context),
                likedBlogPostsBloc: BlocProvider.of<LikedBlogPostsBloc>(context),
                savedBlogPostsBloc: BlocProvider.of<SavedBlogPostsBloc>(context),
              )..add(BlogPostsSavedListLoadRequested()),
            ),
            BlocProvider(
              create: (context) => BlogPostsListBloc(
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                savedBlogPostsBloc: BlocProvider.of<SavedBlogPostsBloc>(context),
                likedBlogPostsBloc: BlocProvider.of<LikedBlogPostsBloc>(context),
                blogPostsSearchFilterBloc: BlocProvider.of<BlogPostsSearchFilterBloc>(context),
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              )..add(BlogPostsListLoadRequested()),
            ),
            BlocProvider(
              create: (context) => UserBlogPostsListBloc(
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                likedBlogPostsBloc: BlocProvider.of<LikedBlogPostsBloc>(context),
                savedBlogPostsBloc: BlocProvider.of<SavedBlogPostsBloc>(context),
              )..add(UserBlogPostsListLoadRequested()),
            ),
          ],
          child: BlogPostsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(),
      body: BlocBuilder<BlogsViewSelectorCubit, BlogsViewSelectorState>(
        builder: (context, state) {
          if (state.isAll) {
            return AllBlogsBuilder();
          }

          if (state.isSaved) {
            return SavedBlogsBuilder();
          }

          if (state.isUsers) {
            return UserBlogsBuilder();
          }

          return Container();
        },
      ),
      bottomNavigationBar: BlocBuilder<BlogsViewSelectorCubit, BlogsViewSelectorState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: BlogsViewSelectorState.values.indexOf(state),
            items: BlogsViewSelectorState.values.map(
              (e) {
                return BottomNavigationBarItem(
                  icon: Icon(e.toIcon()),
                  label: e.toBottomNavigationString(),
                );
              },
            ).toList(),
            onTap: (index) {
              BlocProvider.of<BlogsViewSelectorCubit>(context).viewUpdateIndex(index);
            },
          );
        },
      ),
    );
  }
}
