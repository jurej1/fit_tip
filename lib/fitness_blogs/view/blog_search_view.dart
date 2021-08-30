import 'package:fit_tip/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogSearchView extends StatelessWidget {
  const BlogSearchView({Key? key}) : super(key: key);

  static MaterialPageRoute<BlogSearchResult?> route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SearchBloc(),
            ),
            BlocProvider(
              create: (context) => BlogSearchHistoryBloc(),
            ),
            BlocProvider(
              create: (context) => FilteredBlogSearchHistoryBloc(
                blogSearchHistoryBloc: BlocProvider.of<BlogSearchHistoryBloc>(context),
                searchBy: BlocProvider.of<SearchBloc>(context).state.searchBy,
              ),
            )
          ],
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
                bottom: const _SelectByBuilder(),
                value: state.search.value,
                hintText: 'Search...',
                onChanged: (value) {
                  BlocProvider.of<SearchBloc>(context).add(SearchQueryUpdated(value));
                },
                onSubmitted: (value) {
                  Navigator.of(context).pop(
                    BlogSearchResult(
                      query: state.search.value,
                      searchBy: state.searchBy,
                    ),
                  );
                },
                onTrailingTap: () {
                  BlocProvider.of<SearchBloc>(context).add(SearchQueryClerRequested());
                },
              );
            },
          ),
          BlocBuilder<FilteredBlogSearchHistoryBloc, FilteredBlogSearchHistoryState>(
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      margin: EdgeInsets.all(4),
                      child: Text(state.values[index]),
                    );
                  },
                  childCount: state.values.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SelectByBuilder extends StatelessWidget with PreferredSizeWidget {
  const _SelectByBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return SizedBox(
          height: preferredSize.height,
          width: preferredSize.width,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: SearchBy.values.length,
            itemBuilder: (context, index) {
              final item = SearchBy.values[index];
              final bool isSelected = item == state.searchBy;

              return RawChip(
                selected: isSelected,
                label: Text(item.toStringReadable()),
                selectedColor: BlocProvider.of<ThemeBloc>(context).state.accentColor,
                onPressed: () {
                  BlocProvider.of<SearchBloc>(context).add(SearchByUpdated(item));
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 8);
            },
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(35);
}
