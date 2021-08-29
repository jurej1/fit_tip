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
            padding: EdgeInsets.symmetric(horizontal: 19),
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
    );
  }
}
