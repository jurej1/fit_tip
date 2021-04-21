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
    final Size size = MediaQuery.of(context).size;

    return BlocListener<RegisterFormBloc, RegisterFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          showInfoAuthFlushbar(context, title: state.errorMsg);
        }
      },
      child: Scaffold(
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
          suffixIcon: state.email.error == null ? const Icon(Icons.check_rounded, color: Colors.green) : null,
          focusNode: focusNode,
          hintText: 'Email',
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
          hintText: 'Password',
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
          title: 'Sign Up',
          onPressed: () => BlocProvider.of<RegisterFormBloc>(context).add(RegisterFormSubmit()),
          isLoading: state.status.isSubmissionInProgress,
        );
      },
    );
  }
}
