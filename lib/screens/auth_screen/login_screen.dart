import 'package:bobby/bloc/auth_bloc/auth_bloc.dart';
import 'package:bobby/bloc/login_bloc/login_bloc.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:bobby/screens/auth_screen/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final UserRepositories userRepositories;

  const LoginScreen({super.key, required this.userRepositories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
              userRepositories: userRepositories,
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
        },
        child: LoginForm(
          userRepositories: userRepositories,
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        ),
      ),
    );
  }
}
