import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogTitleInput extends StatelessWidget {
  const BlogTitleInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.title.value,
          decoration: InputDecoration(
            labelText: 'Title',
            errorText: state.title.invalid ? 'Invalid' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostTitleUpdated(value));
          },
        );
      },
    );
  }
}
