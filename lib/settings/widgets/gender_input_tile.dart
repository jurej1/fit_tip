import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings.dart';

class GenderInputTile extends StatelessWidget {
  const GenderInputTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
      builder: (context, profileState) {
        return ListTile(
          key: const ValueKey('Gender'),
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Gender',
          ),
          trailing: IgnorePointer(
            ignoring: !profileState.isEditMode,
            child: DropdownButton<Gender>(
              value: profileState.gender.value,
              items: Gender.values
                  .map(
                    (e) => DropdownMenuItem<Gender>(
                      key: ValueKey(e),
                      child: Text(
                        describeEnum(e),
                      ),
                      value: e,
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsGenderUpdated(value));
              },
            ),
          ),
        );
      },
    );
  }
}
