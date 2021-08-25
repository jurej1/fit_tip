import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerDisplayer extends StatelessWidget {
  const BannerDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return Container(
          width: size.width,
          height: 200,
          child: state.banner.value != null ? Image.file(state.banner.value!) : null,
        );
      },
    );
  }
}
