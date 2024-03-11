import 'package:bobby/bloc/auth_bloc/auth.dart';
import 'package:bobby/bloc/register_bloc/register_bloc.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:bobby/screens/auth_screen/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepositories userRepositories;
  const RegisterScreen({super.key, required this.userRepositories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return RegisterBloc(
              userRepositories: userRepositories,
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
        },
        child: RegisterForm(
          userRepositories: userRepositories,
        ),
      ),
    );
  }
}
