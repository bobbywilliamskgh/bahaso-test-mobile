import 'package:bobby/bloc/auth_bloc/auth.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:bobby/screens/auth_screen/login_screen.dart';
import 'package:bobby/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final UserRepositories userRepositories = UserRepositories();
  runApp(
    BlocProvider(
      create: ((context) {
        return AuthenticationBloc(userRepositories: userRepositories)
          ..add(AppStarted());
      }),
      child: MyApp(
        userRepositories: userRepositories,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepositories userRepositories;
  const MyApp({super.key, required this.userRepositories});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return MainScreen();
        }
        if (state is AuthenticationUnauthenticated) {
          return LoginScreen(userRepositories: userRepositories);
        }
        if (state is AuthenticationLoading) {
          return Scaffold(
            body: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: CircularProgressIndicator(),
        );
      }),
    );
  }
}
