import 'dart:convert';

import 'package:bobby/bloc/auth_bloc/auth.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:bobby/style/theme.dart' as Style;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<List<dynamic>> fetchQuizList() async {
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
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = response.data;
    List<dynamic> data = responseBody['data'];
    print(data);
    print('token :');
    print(token);
    return data;
  } else {
    throw Exception("Failed to load quiz");
  }
}

class MainScreen extends StatefulWidget {
  final UserRepositories userRepositories;
  const MainScreen({super.key, required this.userRepositories});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<dynamic>> futureListQuiz;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureListQuiz = fetchQuizList();
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
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: futureListQuiz,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> quiz = snapshot.data![index];
                  List<dynamic> questions = quiz['question'];
                  return Container(
                    // height: 300,
                    child: Column(
                      children: [for (var quest in questions) Text(quest)],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
