import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogSearchView extends StatelessWidget {
  const BlogSearchView({Key? key}) : super(key: key);

  static MaterialPageRoute<String?> route(BuildContext context) {
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
                  Navigator.of(context).pop(state.search.value.trim());
                },
                onTrailingTap: () {
                  BlocProvider.of<SearchBloc>(context).add(SearchQueryClerRequested());
                },
              );
            },
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, indext) {
                return Container(
                  height: 30,
                  margin: EdgeInsets.all(4),
                  color: Colors.red,
                );
              },
              childCount: 59,
            ),
          ),
        ],
      ),
    );
  }
}
