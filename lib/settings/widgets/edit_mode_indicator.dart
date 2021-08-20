import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../settings.dart';

class EditModeIndicator extends StatelessWidget {
  const EditModeIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
      builder: (context, profileState) {
        return AnimatedContainer(
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
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 5,
                        color: profileState.status.isSubmissionInProgress ? Colors.transparent : state.accentColor,
                        child: profileState.status.isSubmissionInProgress
                            ? LinearProgressIndicator(
                                color: state.accentColor,
                              )
                            : Container(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
