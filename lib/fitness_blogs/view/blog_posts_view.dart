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
              )..add(
                  BlogPostsSavedListLoadRequested(
                    likedBlogIds: BlocProvider.of<LikedBlogPostsBloc>(context).state,
                    savedBlogIds: BlocProvider.of<SavedBlogPostsBloc>(context).state,
                    userId: BlocProvider.of<AuthenticationBloc>(context).state.user?.uid,
                  ),
                ),
            ),
            BlocProvider(
              create: (context) => BlogPostsListBloc(
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                savedBlogPostsBloc: BlocProvider.of<SavedBlogPostsBloc>(context),
                likedBlogPostsBloc: BlocProvider.of<LikedBlogPostsBloc>(context),
              )..add(
                  BlogPostsListLoadRequested(
                    likedBlogs: BlocProvider.of<LikedBlogPostsBloc>(context).state,
                    savedBlogs: BlocProvider.of<SavedBlogPostsBloc>(context).state,
                    userId: BlocProvider.of<AuthenticationBloc>(context).state.user?.uid,
                  ),
                ),
            ),
            BlocProvider(
              create: (context) => UserBlogPostsListBloc(
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
              )..add(
                  UserBlogPostsListLoadRequested(
                    userId: BlocProvider.of<AuthenticationBloc>(context).state.user?.uid,
                    likedBlogs: BlocProvider.of<LikedBlogPostsBloc>(context).state,
                    savedBlogs: BlocProvider.of<SavedBlogPostsBloc>(context).state,
                  ),
                ),
            ),
          ],
          child: BlogPostsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        BlocProvider.of<BlogPostsSavedListBloc>(context).add(
          BlogPostsSavedListLoadRequested(
            likedBlogIds: BlocProvider.of<LikedBlogPostsBloc>(context, listen: true).state,
            savedBlogIds: BlocProvider.of<SavedBlogPostsBloc>(context, listen: true).state,
            userId: state.user?.uid,
          ),
        );

        BlocProvider.of<BlogPostsListBloc>(context).add(
          BlogPostsListLoadRequested(
            likedBlogs: BlocProvider.of<LikedBlogPostsBloc>(context, listen: true).state,
            savedBlogs: BlocProvider.of<SavedBlogPostsBloc>(context, listen: true).state,
            userId: state.user?.uid,
          ),
        );
      },
      child: Scaffold(
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
      ),
    );
  }
}
