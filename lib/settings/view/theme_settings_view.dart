import 'package:fit_tip/settings/blocs/blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSettingsView extends StatelessWidget {
  const ThemeSettingsView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return ThemeSettingsView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme settings'),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Theme Mode'),
                  trailing: DropdownButton<ThemeMode>(
                    value: state.themeMode,
                    items: ThemeMode.values
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(
                              describeEnum(e),
                            ),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (mode) {
                      BlocProvider.of<ThemeBloc>(context).add(ThemeThemeModeUpdated(mode));
                    },
                  ),
                ),
                Text('Accent Color'),
                Container(
                  height: 30,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.availableAccentColors.length,
                    itemBuilder: (context, index) {
                      final item = state.availableAccentColors[index];
                      final bool isSelected = state.isAccentColorSelected(item);
                      final double size = isSelected ? 25 : 20;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item,
                          border: isSelected
                              ? Border.all(
                                  color: state.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                  width: 1,
                                )
                              : null,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 20);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
