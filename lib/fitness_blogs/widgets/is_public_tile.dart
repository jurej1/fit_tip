import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class IsPublicTile extends StatelessWidget {
  const IsPublicTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Public'),
          trailing: Switch(
            value: state.isPublic,
            onChanged: (value) {
              BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostPublicPressed());
            },
          ),
        );
      },
    );
  }
}
