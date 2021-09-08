import 'dart:developer';

import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogPostTile extends StatelessWidget {
  BlogPostTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BlogPost item;

  final BorderRadius _borderRadius = BorderRadius.circular(13);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: Material(
          elevation: 3,
          color: BlocProvider.of<ThemeBloc>(context, listen: true).state.accentColor,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(BlogPostDetailView.route(context, item));
            },
            child: LayoutBuilder(
              builder: (context, size) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.bannerUrl != null)
                      SizedBox(
                        height: size.maxHeight * 0.7,
                        width: size.maxWidth,
                        child: item.bannerUrl != null
                            ? Image.network(
                                item.bannerUrl!,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!)
                                        : null,
                                  );
                                },
                              )
                            : null,
                      ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                            ),
                            SizedBox(
                              height: 40,
                              width: size.maxWidth,
                              child: Material(
                                color: Colors.red,
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
