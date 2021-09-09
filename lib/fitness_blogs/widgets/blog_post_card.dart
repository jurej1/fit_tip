import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogPostCard extends StatelessWidget {
  BlogPostCard._({
    Key? key,
  }) : super(key: key);

  static Widget provider(BlogPost post) {
    return MultiBlocProvider(
      key: ValueKey(post),
      providers: [
        BlocProvider(
          create: (context) => BlogPostCardBloc(blogPost: post),
        ),
        BlocProvider(
          create: (context) => BlogPostSaveCubit(
            blogId: post.id,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            blogRepository: RepositoryProvider.of<BlogRepository>(context),
            initialValue: post.isSaved,
          ),
        ),
        BlocProvider(
          create: (context) => BlogPostLikeCubit(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            blogId: post.id,
            blogRepository: RepositoryProvider.of<BlogRepository>(context),
            initialValue: post.like,
            likesAmount: post.likes,
          ),
        )
      ],
      child: BlogPostCard._(),
    );
  }

  final BorderRadius _borderRadius = BorderRadius.circular(13);
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BlogPostCardBloc, BlogPost>(
          listenWhen: (p, c) => p.isSaved != c.isSaved,
          listener: (context, state) {
            if (state.isSaved) {
              BlocProvider.of<BlogPostsSavedBloc>(context).add(BlogPostsItemAdded(state));
            }

            if (!state.isSaved) {
              BlocProvider.of<BlogPostsSavedBloc>(context).add(BlogPostsItemRemoved(state));
            }
          },
        ),
        BlocListener<BlogPostCardBloc, BlogPost>(
          listenWhen: (p, c) => p.isSaved == c.isSaved,
          listener: (context, state) {
            BlocProvider.of<BlogPostsSavedBloc>(context).add(BlogPostsItemUpdated(state));
          },
        ),
        BlocListener<BlogPostCardBloc, BlogPost>(
          listener: (context, state) {
            BlocProvider.of<BlogPostsListBloc>(context).add(BlogPostsItemUpdated(state));
          },
        ),
      ],
      child: BlocBuilder<BlogPostCardBloc, BlogPost>(
        builder: (context, state) {
          return SizedBox(
            height: state.bannerUrl != null ? 270 : 110,
            child: ClipRRect(
              borderRadius: _borderRadius,
              child: Material(
                elevation: 3,
                color: BlocProvider.of<ThemeBloc>(context, listen: true).state.accentColor,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(BlogPostDetailView.route(context, state));
                  },
                  child: LayoutBuilder(
                    builder: (context, size) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ImageBuilder(size: size),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BlocBuilder<BlogPostCardBloc, BlogPost>(
                                            buildWhen: (p, c) => p.title != c.title,
                                            builder: (context, item) {
                                              return Text(
                                                item.title,
                                                maxLines: 3,
                                                overflow: TextOverflow.fade,
                                              );
                                            },
                                          ),
                                          _ActionsRowBuilder(size: size),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ImageBuilder extends StatelessWidget {
  const _ImageBuilder({
    Key? key,
    required this.size,
  }) : super(key: key);

  final BoxConstraints size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogPostCardBloc, BlogPost>(
      buildWhen: (p, c) => p.bannerUrl != c.bannerUrl,
      builder: (context, item) {
        if (item.bannerUrl != null) {
          return SizedBox(
            height: size.maxHeight * 0.6,
            width: size.maxWidth,
            child: item.bannerUrl != null
                ? Image.network(
                    item.bannerUrl!,
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
                  )
                : null,
          );
        }
        return Container();
      },
    );
  }
}

class _ActionsRowBuilder extends StatelessWidget {
  const _ActionsRowBuilder({
    Key? key,
    required this.size,
  }) : super(key: key);

  final BoxConstraints size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 40,
        width: size.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BlocConsumer<BlogPostLikeCubit, BlogPostLikeState>(
              listener: (context, state) {
                if (state is BlogPostLikeSuccess) {
                  BlocProvider.of<BlogPostCardBloc>(context).add(BlogPostCardLiked(state.like, state.likesAmount));
                }
              },
              builder: (context, state) {
                return _ActionIcon(
                  icon: state.like.isYes ? Icons.favorite : Icons.favorite_outline,
                  text: state.likesAmount.toString(),
                  onTap: () {
                    if (state is! BlogPostLikeLoading) {
                      BlocProvider.of<BlogPostLikeCubit>(context).buttonPressed();
                    }
                  },
                );
              },
            ),
            BlocConsumer<BlogPostSaveCubit, BlogPostSaveState>(
              listener: (context, state) {
                if (state is BlogPostSaveLoadSuccess) {
                  BlocProvider.of<BlogPostCardBloc>(context).add(BlogPostCardSaved(state.isSaved));
                }
              },
              builder: (context, state) {
                return _ActionIcon(
                  icon: state.isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  onTap: () {
                    if (state is! BlogPostSaveLoading) {
                      BlocProvider.of<BlogPostSaveCubit>(context).buttonPressed();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    Key? key,
    required this.icon,
    this.text,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String? text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkResponse(
          onTap: onTap,
          radius: 20,
          child: Icon(icon),
        ),
        if (this.text != null) const SizedBox(width: 4),
        if (this.text != null)
          Text(
            text!,
            style: TextStyle(fontSize: 18),
          ),
      ],
    );
  }
}
