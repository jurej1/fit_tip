import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../authentication.dart';

class CompleteAccountView extends StatelessWidget {
  const CompleteAccountView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => CompleteAccountFormBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
          ),
          child: CompleteAccountView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete account view'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              BlocProvider.of<CompleteAccountFormBloc>(context).add(CompleteAccountFormSubmit());
            },
          ),
        ],
      ),
      body: BlocConsumer<CompleteAccountFormBloc, CompleteAccountFormState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Failure')));
          }
          if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.status.isSubmissionInProgress) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              _DisplayNameInput(),
              _FirstNameInput(),
              _LastNameInput(),
              _IntroductionLineInput(),
              _GenderInputTile(),
              _MeasurmentSystemInputTile(),
            ],
          );
        },
      ),
    );
  }
}

class _DisplayNameInput extends StatelessWidget {
  const _DisplayNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteAccountFormBloc, CompleteAccountFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.displayName.value,
          decoration: InputDecoration(
            labelText: 'Display name',
            errorText: state.displayName.invalid ? 'Invalid' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<CompleteAccountFormBloc>(context).add(CompleteAccountFormDisplayNameUpdated(value));
          },
        );
      },
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  const _FirstNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteAccountFormBloc, CompleteAccountFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.firstName.value,
          decoration: InputDecoration(
            labelText: 'First name',
            errorText: state.firstName.invalid ? 'Invalid' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<CompleteAccountFormBloc>(context).add(CompleteAccountFormFirstNameUpdated(value));
          },
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  const _LastNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteAccountFormBloc, CompleteAccountFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.lastName.value,
          decoration: InputDecoration(
            labelText: 'Last name',
            errorText: state.lastName.invalid ? 'Invalid' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<CompleteAccountFormBloc>(context).add(CompleteAccountFormLastNameUpdated(value));
          },
        );
      },
    );
  }
}

class _GenderInputTile extends StatelessWidget {
  const _GenderInputTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteAccountFormBloc, CompleteAccountFormState>(
      builder: (context, state) {
        return ListTile(
          title: const Text('Gender'),
          trailing: DropdownButton<Gender>(
            value: state.gender.value,
            items: Gender.values
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e.toStringReadable()),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (Gender? value) {
              BlocProvider.of<CompleteAccountFormBloc>(context).add(CompleteAccountFormGenderUpdated(value));
            },
          ),
        );
      },
    );
  }
}

class _IntroductionLineInput extends StatelessWidget {
  const _IntroductionLineInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteAccountFormBloc, CompleteAccountFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.introduction.value,
          decoration: InputDecoration(
            labelText: 'Introduction line',
            errorText: state.introduction.invalid ? 'Invalid' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<CompleteAccountFormBloc>(context).add(CompleteAccountFormIntroductionUpdated(value));
          },
        );
      },
    );
  }
}

class _MeasurmentSystemInputTile extends StatelessWidget {
  const _MeasurmentSystemInputTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteAccountFormBloc, CompleteAccountFormState>(
      builder: (context, state) {
        return ListTile(
          title: Text('Measurment system'),
          trailing: DropdownButton<MeasurmentSystem>(
            value: state.measurmentSystem.value,
            items: MeasurmentSystem.values
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(
                      e.toStringReadable(),
                    ),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (MeasurmentSystem? value) {
              BlocProvider.of<CompleteAccountFormBloc>(context).add(CompleteAccountFormMeasurmentSystemUpdated(value));
            },
          ),
        );
      },
    );
  }
}
