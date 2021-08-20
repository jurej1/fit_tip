import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
