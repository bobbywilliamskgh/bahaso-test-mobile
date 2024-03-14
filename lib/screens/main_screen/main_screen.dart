import 'package:bobby/bloc/auth_bloc/auth.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:bobby/style/theme.dart' as Style;
import 'package:bobby/widgets/video_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

Future<List<dynamic>> fetchQuizList() async {
  final UserRepositories userRepositories = UserRepositories();
  var url =
      'https://devbe.bahaso.com/api/v2/quiz/attempt-data-general-english-example';
  final Dio dio = Dio();
  var token = await userRepositories.getToken();
  Response response = await dio.get(url);
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

Future<Map<String, dynamic>> fetchUserData() async {
  final UserRepositories userRepositories = UserRepositories();
  var url = 'https://reqres.in/api/users';
  final Dio dio = Dio();
  var email = await userRepositories.getEmail();
  print('email : $email');
  Response response = await dio.get(url);
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = response.data;
    List<dynamic> data = responseBody['data'];
    print(data);
    Map<String, dynamic> user =
        data.firstWhere((user) => user['email'] == email);
    print(user);
    return user;
  } else {
    throw Exception('Failed to get user data');
  }
}

class MainScreen extends StatefulWidget {
  final UserRepositories userRepositories;
  const MainScreen({super.key, required this.userRepositories});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<Map<String, dynamic>> futureUser;
  late Future<List<dynamic>> futureListQuiz;
  int currentQuizIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureUser = fetchUserData();
    futureListQuiz = fetchQuizList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FutureBuilder(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String avatarUrl = snapshot.data!['avatar'];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
        title: FutureBuilder(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('snapshot');
              print(snapshot.data);
              String firstName = snapshot.data!['first_name'];
              String lastName = snapshot.data!['last_name'];
              return Text('Halo, $firstName $lastName !');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
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
      body: FutureBuilder(
        future: futureListQuiz,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> quizList = snapshot.data!;
            Map<String, dynamic> quiz = quizList[currentQuizIndex];
            bool isMultipleChoice = quiz.containsKey('data');
            List<dynamic> choices = isMultipleChoice ? quiz['data'] : [];
            print('choices');
            print(choices);
            List<dynamic> questions = quiz['question'];
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all()),
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            return (questions[index].contains('.jpg') ||
                                    questions[index].contains('.png'))
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(questions[index]),
                                  )
                                : (questions[index].contains('.mp3') ||
                                        questions[index].contains('.mp4'))
                                    ? Container(
                                        padding: const EdgeInsets.all(8.0),
                                        height: 100,
                                        width: 100,
                                        child: VideoPlayerWidget(
                                            videoUrl: questions[index]))
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                            child: Text(questions[index])),
                                      );
                          },
                        ),
                        Column(
                          children: choices.isNotEmpty
                              ? choices
                                  .map((choice) => Text(choice['text']))
                                  .toList()
                              : [],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: quizList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentQuizIndex = index;
                            });
                            ;
                          },
                          child: Container(
                              margin: EdgeInsets.all(5),
                              height: 50,
                              width: 50,
                              child: MaterialButton(
                                shape: CircleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    currentQuizIndex = index;
                                  });
                                },
                                child: Text('${index + 1}'),
                                color: Style.Colors.mainColor,
                                textColor: Colors.white,
                              )),
                        );
                      }),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
