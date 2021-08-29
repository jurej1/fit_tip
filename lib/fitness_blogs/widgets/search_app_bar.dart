import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:fit_tip/settings/settings.dart';
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
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return Container(
                color: BlocProvider.of<ThemeBloc>(context, listen: true).state.accentColor,
                padding: EdgeInsets.only(top: padding.top),
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        BlocProvider.of<BlogsViewAppBarCubit>(context).backIconButtonPressedOnSearch();
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                        ),
                      ),
                    ),
                    if (!state.isQueryEmpty)
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          //TODO the icon is only going to be displayed when the query is not going to be null
                        },
                      )
                  ],
                ),
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
