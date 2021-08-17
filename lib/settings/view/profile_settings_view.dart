import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:formz/formz.dart';

import '../settings.dart';

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return BlocProvider(
          create: (context) => ProfileSettingsBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
          ),
          child: ProfileSettingsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Sorry there was an error'),
            ),
          );
        } else if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Data updated successfully'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Settings'),
          actions: [
            BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.isEditMode,
                  child: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsFormSubmit());
                    },
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsEditButtonPressed());
              },
            )
          ],
        ),
        body: BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
          builder: (context, profileState) {
            if (profileState.authenticationStatus != AuthenticationStatus.authenticated) {
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
                    height: profileState.isEditMode ? 30 : 0,
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
                                height: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: profileState.status.isSubmissionInProgress ? Colors.transparent : state.accentColor,
                                ),
                                child: profileState.status.isSubmissionInProgress
                                    ? LinearProgressIndicator(
                                        color: state.accentColor,
                                      )
                                    : Container(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextFormField(
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
                  ),
                  TextFormField(
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
                  ),
                  Text(
                    'Date joined ${profileState.user != null ? DateFormat.yMMMd().format(profileState.user!.dateJoined!) : ''}',
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Height: ${profileState.user?.height == null ? 'unknow' : profileState.user?.height}'),
                  ),
                  ListTile(
                    key: const ValueKey('Birthday'),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
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
                  TextFormField(
                    key: const ValueKey('email'),
                    initialValue: profileState.user?.email ?? 'None',
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: InputBorder.none,
                    ),
                    enabled: profileState.isEditMode ? true : false,
                    onChanged: (value) {
                      BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsEmailUpdated(value));
                    },
                  ),
                  ListTile(
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
