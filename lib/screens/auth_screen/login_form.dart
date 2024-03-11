import 'package:bobby/bloc/auth_bloc/auth.dart';
import 'package:bobby/bloc/login_bloc/login_bloc.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:bobby/screens/auth_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../style/theme.dart' as Style;

class LoginForm extends StatefulWidget {
  final UserRepositories userRepositories;
  final AuthenticationBloc authenticationBloc;

  const LoginForm(
      {super.key,
      required this.userRepositories,
      required this.authenticationBloc});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal login.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: ((context, state) {
          return Padding(
            padding: EdgeInsets.only(right: 20, left: 20, top: 80),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    padding: EdgeInsets.only(bottom: 20, top: 40),
                    child: const Text(
                      'Quiz App Bahaso',
                      style: TextStyle(
                          color: Style.Colors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Style.Colors.mainColor),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Style.Colors.mainColor),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Style.Colors.mainColor),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Style.Colors.mainColor),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: state is LoginLoading
                        ? Center(
                            child: Container(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator()),
                          )
                        : ElevatedButton(
                            onPressed: _onLoginButtonPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Style.Colors.mainColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Tidak memiliki akun?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(
                                    userRepositories: widget.userRepositories),
                              ),
                            );
                          },
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                              color: Style.Colors.mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
