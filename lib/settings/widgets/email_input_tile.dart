import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings.dart';

class EmailInputTile extends StatelessWidget {
  const EmailInputTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
      builder: (context, profileState) {
        return TextFormField(
          key: const ValueKey('email'),
          initialValue: profileState.email.value,
          decoration: InputDecoration(
            labelText: 'Email',
            border: InputBorder.none,
          ),
          enabled: profileState.isEditMode ? true : false,
          onChanged: (value) {
            BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsEmailUpdated(value));
          },
        );
      },
    );
  }
}
