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
              create: (context) => BlogsViewSelectorCubit(),
              child: Container(),
            ),
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
            BlocProvider(
              create: (context) => BlogPostsSavedListBloc(
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                savedBlogPostsBloc: BlocProvider.of<SavedBlogPostsBloc>(context),
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                likedBlogPostsBloc: BlocProvider.of<LikedBlogPostsBloc>(context),
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
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
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
      body: BlocBuilder<BlogsViewSelectorCubit, BlogsViewSelectorState>(
        builder: (context, state) {
          if (state.isAll) {
            return _AllBlogPostsListBuilder();
          }

          if (state.isSaved) {
            return _SavedBlogPostsListBuilder();
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

class _AllBlogPostsListBuilder extends StatelessWidget {
  const _AllBlogPostsListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<BlogPostsListBloc, BlogPostsListState>(
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
    );
  }
}

class _SavedBlogPostsListBuilder extends StatelessWidget {
  const _SavedBlogPostsListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<BlogPostsSavedListBloc, BlogPostsSavedListState>(
      builder: (context, state) {
        if (state is BlogPostsSavedListLoading) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is BlogPostsSavedListLoadSuccess) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              itemCount: state.hasReachedMax ? state.blogs.length : state.blogs.length,
              itemBuilder: (context, index) {
                return index >= state.blogs.length ? BottomLoader() : BlogPostTile(item: state.blogs[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            ),
          );
        } else if (state is BlogPostsSavedListFailure) {
          return Center(
            child: const Text('Sorry. There was an error.'),
          );
        }
        return Container();
      },
    );
  }
}
