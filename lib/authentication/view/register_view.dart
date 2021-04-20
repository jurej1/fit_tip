import 'package:fit_tip/authentication/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../authentication.dart';

class RegisterView extends StatefulWidget {
  static const routeName = 'register_view';

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        BlocProvider.of<RegisterFormBloc>(context).add(RegisterEmailUnfocused());
        FocusScope.of(context).requestFocus(passwordFocusNode);
      }
    });

    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        BlocProvider.of<RegisterFormBloc>(context).add(RegisterPasswordUnfocused());
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _EmailInputField(focusNode: emailFocusNode),
            _PasswordInputField(focusNode: passwordFocusNode),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInputField extends StatelessWidget {
  final FocusNode focusNode;

  const _EmailInputField({Key? key, required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return InputField(
          focusNode: focusNode,
          helperText: 'Email',
          preffixIcon: const Icon(Icons.email),
          errorText: state.email.invalid ? 'Please enter a valid email' : null,
          onChanged: (val) => BlocProvider.of<RegisterFormBloc>(context).add(RegisterEmailChanged(val)),
        );
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  final FocusNode focusNode;

  const _PasswordInputField({Key? key, required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return InputField(
          helperText: 'Password',
          obscure: true,
          onChanged: (val) => BlocProvider.of<RegisterFormBloc>(context).add(RegisterPasswordChanged(val)),
          preffixIcon: Icon(Icons.vpn_key),
          errorText: state.password.invalid ? 'Please enter a valid password' : null,
          focusNode: focusNode,
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return SubmitButton(
          title: 'Submit',
          onPressed: () => BlocProvider.of<RegisterFormBloc>(context).add(RegisterFormSubmit()),
          isLoading: state.status.isSubmissionInProgress,
        );
      },
    );
  }
}
