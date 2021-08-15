import 'package:fit_tip/settings/blocs/blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSettingsView extends StatelessWidget {
  const ThemeSettingsView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        // return BlocProvider(
        //   create: (context) => ThemeBloc(),
        //   child: ThemeSettingsView(),
        // );

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
              ],
            ),
          );
        },
      ),
    );
  }
}
