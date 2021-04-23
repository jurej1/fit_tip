import 'package:fit_tip/authentication/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../authentication.dart';

class LoginView extends StatefulWidget {
  static const routeName = 'login_view';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        BlocProvider.of<LoginFormBloc>(context).add(LoginEmailUnfocused());
        FocusScope.of(context).requestFocus(passwordFocusNode);
      }
    });

    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        BlocProvider.of<LoginFormBloc>(context).add(LoginPasswordUnfocused());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.3),
              _EmailInputField(focusNode: emailFocusNode),
              const SizedBox(height: 25),
              _PasswordInputField(focusNode: passwordFocusNode),
              const SizedBox(height: 25),
              _SubmitButton(),
            ],
          ),
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
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, state) {
        return InputField(
          action: TextInputAction.next,
          focusNode: focusNode,
          onChanged: (val) => BlocProvider.of<LoginFormBloc>(context).add(LoginEmailChanged(val)),
          hintText: 'Email',
          errorText: state.email.invalid ? 'Please enter a valid email' : null,
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
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, state) {
        return InputField(
          focusNode: focusNode,
          action: TextInputAction.done,
          hintText: 'Password',
          obscure: true,
          errorText: state.password.invalid ? 'Please enter a valid password' : null,
          onChanged: (val) => BlocProvider.of<LoginFormBloc>(context).add(LoginPasswordChanged(val)),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return SubmitButton(
          title: 'Log In',
          isLoading: state.status.isSubmissionInProgress,
          onPressed: () => BlocProvider.of<LoginFormBloc>(context).add(LoginFormSubmit()),
        );
      },
    );
  }
}
