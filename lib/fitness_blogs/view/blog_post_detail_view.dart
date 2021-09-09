import 'dart:developer';

import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPostDetailView extends StatelessWidget {
  const BlogPostDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(
    BuildContext context,
    BlogPost blogPost,
  ) {
    final blogPostsSavedListBloc = BlocProvider.of<BlogPostsSavedBloc>(context);
    final blogPostsListBloc = BlocProvider.of<BlogPostsListBloc>(context);
    final userBlogPostsBloc = BlocProvider.of<UserBlogPostsBloc>(context);
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            //Blogs with blogPosts
            BlocProvider.value(value: blogPostsSavedListBloc),
            BlocProvider.value(value: blogPostsListBloc),
            BlocProvider.value(value: userBlogPostsBloc),
            //Save, like and delete feature blocs
            BlocProvider(
              create: (context) => BlogPostSaveCubit(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                blogId: blogPost.id,
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                initialValue: blogPost.isSaved,
              ),
            ),
            BlocProvider(
              create: (context) => BlogPostLikeCubit(
                blogId: blogPost.id,
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                initialValue: blogPost.like,
                likesAmount: blogPost.likes,
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              ),
            ),
            BlocProvider(
              create: (context) => BlogPostDeleteBloc(
                blogId: blogPost.id,
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
                isAuthor: blogPost.isAuthor,
              ),
            ),
            //About author bloc
            BlocProvider(
              create: (context) => AboutAuthorBloc(
                blogRepository: RepositoryProvider.of<BlogRepository>(context),
              )..add(AboutAuthorLoadRequested(blogPost.authorId)),
            ), //Detail blog view bloc
            BlocProvider(
              create: (context) => BlogPostDetailBloc(blogPost: blogPost),
            ),
          ],
          child: const BlogPostDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<BlogPostDetailBloc, BlogPostDetailState>(
          listenWhen: (p, c) => p.blogPost.isSaved != c.blogPost.isSaved,
          listener: (context, state) {
            if (state.blogPost.isSaved) {
              BlocProvider.of<BlogPostsSavedBloc>(context).add(BlogPostsItemAdded(state.blogPost));
            }

            if (!state.blogPost.isSaved) {
              BlocProvider.of<BlogPostsSavedBloc>(context).add(BlogPostsItemRemoved(state.blogPost));
            }
          },
        ),
        BlocListener<BlogPostDetailBloc, BlogPostDetailState>(
          listenWhen: (p, c) => p.blogPost.isSaved == c.blogPost.isSaved,
          listener: (context, state) {
            BlocProvider.of<BlogPostsSavedBloc>(context).add(BlogPostsItemUpdated(state.blogPost));
          },
        ),
        BlocListener<BlogPostDetailBloc, BlogPostDetailState>(
          listener: (context, state) {
            BlocProvider.of<BlogPostsListBloc>(context).add(BlogPostsItemUpdated(state.blogPost));

            BlocProvider.of<UserBlogPostsBloc>(context).add(BlogPostsItemUpdated(state.blogPost));
          },
        ),
      ],
      child: Scaffold(
        appBar: const DetailBlogPostAppBar(),
        body: BlocBuilder<BlogPostDetailBloc, BlogPostDetailState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.all(10),
              children: [
                if (state.blogPost.bannerUrl != null)
                  Container(
                    height: size.width,
                    width: size.width,
                    child: Image.network(
                      state.blogPost.bannerUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  state.blogPost.title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(state.blogPost.content),
                const SizedBox(height: 10),
                const BlogPostTagsDisplayer(),
                const SizedBox(height: 10),
                const AboutAuthorDisplayer(),
              ],
            );
          },
        ),
      ),
    );
  }
}
