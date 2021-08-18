import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings.dart';

class SubmitProfileFormButton extends StatelessWidget {
  const SubmitProfileFormButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
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
    );
  }
}
