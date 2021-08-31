import 'package:fit_tip/fitness_blogs/fitness_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagsInputDisplayer extends StatelessWidget {
  const TagsInputDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return Wrap(
          spacing: 10,
          children: state.tags.value
              .map(
                (e) => Chip(
                  label: Text(e),
                  onDeleted: () {
                    BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostTagRemoved(e));
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}
