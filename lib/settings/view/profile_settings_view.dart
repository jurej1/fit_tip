import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../settings.dart';

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return BlocProvider(
          create: (context) => ProfileSettingsBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          ),
          child: ProfileSettingsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsEditButtonPressed());
            },
          )
        ],
      ),
      body: BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
        builder: (context, state) {
          if (state.authenticationStatus != AuthenticationStatus.authenticated) {
            return Center(
              child: Text('Sorry there was an error'),
            );
          }

          return SizedBox(
            height: size.height,
            width: size.width,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: state.isEditMode ? 30 : 0,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Editing Mode',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, state) {
                            return Container(
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: state.accentColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  key: ValueKey('displayName'),
                  initialValue: state.user?.displayName ?? 'None',
                  decoration: InputDecoration(
                    labelText: 'Display name',
                    border: InputBorder.none,
                  ),
                  enabled: state.isEditMode ? true : false,
                  onChanged: (value) {
                    BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsDisplayNameUpdated(value));
                  },
                ),
                TextFormField(
                  key: ValueKey('introductionLine'),
                  initialValue: state.user?.introduction ?? 'None',
                  decoration: InputDecoration(
                    labelText: 'Introduction',
                    border: InputBorder.none,
                  ),
                  enabled: state.isEditMode ? true : false,
                  onChanged: (value) {
                    BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsIntroductionLineUpdated(value));
                  },
                ),
                Text(
                  'Date joined ${state.user != null ? DateFormat.yMMMd().format(state.user!.dateJoined!) : ''}',
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Height: ${state.user?.height == null ? 'unknow' : state.user?.height}'),
                ),
                ListTile(
                  key: ValueKey('Birthday'),
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Birthday ',
                  ),
                  trailing: Text(
                    '${state.user != null && state.user?.birthdate != null ? DateFormat.yMMMd().format(state.user!.birthdate!) : 'Unknown'}',
                  ),
                  onTap: () async {
                    final now = DateTime.now();
                    final date = await showDatePicker(
                      context: context,
                      initialDate: state.user?.birthdate ?? now,
                      firstDate: DateTime(now.year),
                      lastDate: DateTime(now.year, DateTime.december, 31),
                    );

                    BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsBirthdayUpdated(date));
                  },
                ),
                TextFormField(
                  key: ValueKey('email'),
                  initialValue: state.user?.email ?? 'None',
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                  ),
                  enabled: state.isEditMode ? true : false,
                  onChanged: (value) {
                    BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsEmailUpdated(value));
                  },
                ),
                ListTile(
                  key: ValueKey('Gender'),
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Gender',
                  ),
                  trailing: IgnorePointer(
                    ignoring: !state.isEditMode,
                    child: DropdownButton<Gender>(
                      value: state.gender.value,
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
