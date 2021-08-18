import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings.dart';

class IntroductionLineInputField extends StatelessWidget {
  const IntroductionLineInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
      builder: (context, profileState) {
        return TextFormField(
          key: const ValueKey('introductionLine'),
          initialValue: profileState.user?.introduction ?? 'None',
          decoration: InputDecoration(
            labelText: 'Introduction',
            border: InputBorder.none,
          ),
          enabled: profileState.isEditMode ? true : false,
          onChanged: (value) {
            BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsIntroductionLineUpdated(value));
          },
        );
      },
    );
  }
}
