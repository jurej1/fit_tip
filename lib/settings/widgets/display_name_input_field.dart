import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings.dart';

class DisplayNameInputField extends StatelessWidget {
  const DisplayNameInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
      builder: (context, profileState) {
        return TextFormField(
          key: const ValueKey('displayName'),
          initialValue: profileState.user?.displayName ?? 'None',
          decoration: InputDecoration(
            labelText: 'Display name',
            border: InputBorder.none,
          ),
          enabled: profileState.isEditMode ? true : false,
          onChanged: (value) {
            BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsDisplayNameUpdated(value));
          },
        );
      },
    );
  }
}
