import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_tip/settings/settings.dart';

class SliverSearchAppBar extends StatelessWidget {
  const SliverSearchAppBar({
    Key? key,
    required this.onChanged,
    required this.onSubmitted,
    required this.value,
    required this.hintText,
    required this.onTrailingTap,
  }) : super(key: key);

  final Function(String value) onChanged;
  final Function(String value) onSubmitted;
  final VoidCallback onTrailingTap;
  final String value;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final accentColor = BlocProvider.of<ThemeBloc>(context, listen: true).state.accentColor;
    return SliverAppBar(
      elevation: 0,
      floating: true,
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight + 10,
      backgroundColor: Colors.transparent,
      title: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: accentColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: value,
                    cursorColor: accentColor,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: onChanged,
                    onFieldSubmitted: onSubmitted,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: value.isNotEmpty
                      ? IconButton(
                          key: ValueKey('Icon'),
                          icon: const Icon(Icons.close),
                          color: accentColor,
                          onPressed: onTrailingTap,
                        )
                      : Container(
                          key: ValueKey('empty_space'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottom: _SelectByBuilder(),
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

              return Chip(
                label: Text(item.toStringReadable()),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: isSelected ? BlocProvider.of<ThemeBloc>(context).state.accentColor : Colors.grey.shade300,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: 5);
            },
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(35);
}
