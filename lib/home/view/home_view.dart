import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/home/home.dart';
import 'package:fit_tip/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeViewSelectorCubit(),
          ),
        ],
        child: HomeView(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text('Logout'),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Home'),
      ),
      bottomNavigationBar: HomeViewSelector(),
    );
  }
}
