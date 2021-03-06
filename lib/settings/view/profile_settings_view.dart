import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/authentication/authentication.dart';
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
            userDataBloc: BlocProvider.of<UserDataBloc>(context),
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
            const SubmitProfileFormButton(),
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
                child: const Text('Sorry there was an error'),
              );
            }

            return SizedBox(
              height: size.height,
              width: size.width,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(10),
                children: [
                  const EditModeIndicator(),
                  const DisplayNameInputField(),
                  const IntroductionLineInputField(),
                  Visibility(
                    visible: !(profileState.user?.isCompleted ?? true),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Your account is not completed! Please put in all your informatio',
                          style: TextStyle(color: Colors.red, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Date joined ${profileState.user != null ? DateFormat.yMMMd().format(profileState.user!.dateJoined!) : ''}',
                    ),
                  ),
                  IgnorePointer(
                    ignoring: !profileState.isEditMode,
                    child: ListTile(
                      key: ValueKey(profileState.height),
                      contentPadding: EdgeInsets.zero,
                      title: Text('Height:'),
                      trailing: Text(' ${profileState.height.value} cm'),
                      onTap: () async {
                        await Navigator.of(context).push<int?>(
                          HeightFormView.route(
                            context,
                            (value) {
                              BlocProvider.of<ProfileSettingsBloc>(context).add(ProfileSettingsHeightUpdated(value));
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const BirthdayInputTile(),
                  const EmailInputTile(),
                  const GenderInputTile(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
