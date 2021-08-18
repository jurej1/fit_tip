import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../settings.dart';

class BirthdayInputTile extends StatelessWidget {
  const BirthdayInputTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
      builder: (context, profileState) {
        return IgnorePointer(
          ignoring: !profileState.isEditMode,
          child: ListTile(
            key: const ValueKey('Birthday'),
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Birthday ',
            ),
            trailing: Text(
              '${profileState.user != null && profileState.user?.birthdate != null ? DateFormat.yMMMd().format(profileState.user!.birthdate!) : 'Unknown'}',
            ),
            onTap: () async {
              final now = DateTime.now();
              final date = await showDatePicker(
                context: context,
                initialDate: profileState.user?.birthdate ?? now,
                firstDate: DateTime(now.year),
                lastDate: DateTime(now.year, DateTime.december, 31),
              );

              BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsBirthdayUpdated(date));
            },
          ),
        );
      },
    );
  }
}
