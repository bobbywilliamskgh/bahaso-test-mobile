import 'package:bobby/bloc/auth_bloc/auth.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:bobby/style/theme.dart' as Style;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void fetchQuizList() async {
  final UserRepositories userRepositories = UserRepositories();
  var url =
      'https://devbe.bahaso.com/api/v2/quiz/attempt-data-general-english-example';
  final Dio dio = Dio();
  var token = await userRepositories.getToken();
  Response response = await dio.post(url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }));
  print(response.data.toString());
  print('token :');
  print(token);
}

class MainScreen extends StatefulWidget {
  final UserRepositories userRepositories;
  const MainScreen({super.key, required this.userRepositories});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchQuizList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(
        child: Text('Halaman setelah login'),
      ),
    );
  }
}
