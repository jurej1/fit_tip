import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogPostTagsDisplayer extends StatelessWidget {
  const BlogPostTagsDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogPostDetailBloc, BlogPostDetailState>(
      builder: (context, state) {
        if (state.blogPost.tags != null && state.blogPost.tags!.isNotEmpty) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Tags:    ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              ...state.blogPost.tags!
                  .map(
                    (e) => GestureDetector(
                      child: Chip(
                        label: Text(e),
                      ),
                    ),
                  )
                  .toList()
            ],
          );
        }
        return Container();
      },
    );
  }
}
