import 'package:bobby/bloc/register_bloc/register_bloc.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:bobby/screens/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bobby/style/theme.dart' as Style;

class RegisterForm extends StatefulWidget {
  final UserRepositories userRepositories;
  const RegisterForm({super.key, required this.userRepositories});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onRegisterButtonPressed() {
      BlocProvider.of<RegisterBloc>(context).add(RegisterButtonPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal register.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is RegisterSuccess) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Registrasi Akun Berhasil'),
                    content: Text(
                        'Silahkan login dengan masukkan email dan password yang telah terdaftar'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: Text('OK'))
                    ],
                  ));
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
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
                      'Daftar Akun',
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
                    child: state is RegisterLoading
                        ? Center(
                            child: Container(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator()),
                          )
                        : ElevatedButton(
                            onPressed: _onRegisterButtonPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Style.Colors.mainColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                  ),
                  // ignore: avoid_unnecessary_containers
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
