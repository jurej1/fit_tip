import 'package:blog_repository/blog_repository.dart';
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
      providers: [
        BlocProvider(
          create: (context) => BlogPostCardBloc(blogPost: post),
        ),
      ],
      child: BlogPostCard._(),
    );
  }

  final BorderRadius _borderRadius = BorderRadius.circular(13);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogPostCardBloc, BlogPost>(
      builder: (context, state) {
        return SizedBox(
          height: state.bannerUrl != null ? 300 : 100,
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
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
                                      const SizedBox(height: 10),
                                      _ActionsRowBuilder(size: size),
                                    ],
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
            height: size.maxHeight * 0.7,
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
    return BlocBuilder<BlogPostCardBloc, BlogPost>(
      builder: (context, item) {
        return Material(
          color: Colors.transparent,
          child: SizedBox(
            height: 40,
            width: size.maxWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionIcon(
                  icon: item.like.isYes ? Icons.favorite : Icons.favorite_outline,
                  text: item.likes.toString(),
                  onTap: () {},
                ),
                _ActionIcon(
                  icon: item.isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
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
        if (this.text != null)
          Text(
            text!,
            style: TextStyle(fontSize: 18),
          ),
      ],
    );
  }
}
