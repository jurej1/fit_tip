import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';

void main() {
  runApp(
    RepositoryProvider(
      create: (context) => AuthenticationRepository(),
      child: App(),
    ),
  );
}
