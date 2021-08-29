import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogSearchView extends StatelessWidget {
  const BlogSearchView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return BlocProvider(
          create: (context) => SearchBloc(),
          child: BlogSearchView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return SliverSearchAppBar(
                value: state.search.value,
                hintText: 'Search...',
                onChanged: (value) {
                  BlocProvider.of<SearchBloc>(context).add(SearchQueryUpdated(value));
                },
                onSubmitted: (value) {
                  //TODO when the value is submitted
                },
                onTrailingTap: () {
                  BlocProvider.of<SearchBloc>(context).add(SearchQueryClerRequested());
                },
              );
            },
          ),
          SliverFillRemaining(
            child: ListView.custom(
              physics: ClampingScrollPhysics(),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container();
                },
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
