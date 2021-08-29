import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchAppBar extends StatelessWidget with PreferredSizeWidget {
  const SearchAppBar({
    Key? key,
    required this.onSubmitted,
  }) : super(key: key);

  final void Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    BlocProvider.of<BlogsViewAppBarCubit>(context).backIconButtonPressed();
                  },
                ),
                title: TextFormField(
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    BlocProvider.of<SearchBloc>(context).add(SearchQueryUpdated(value));
                  },
                  onFieldSubmitted: (value) {
                    onSubmitted(value);
                  },
                ),
                actions: [
                  if (!state.isQueryEmpty)
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        //TODO the icon is only going to be displayed when the query is not going to be null
                      },
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
