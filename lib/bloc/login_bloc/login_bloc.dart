import 'package:bobby/bloc/auth_bloc/auth_bloc.dart';
import 'package:bobby/bloc/auth_bloc/auth_event.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepositories userRepositories;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.userRepositories, required this.authenticationBloc})
      : super(LoginInitial()) {
    on<LoginButtonPressed>(
      (event, emit) async {
        emit(LoginLoading());
        try {
          final token =
              await userRepositories.login(event.email, event.password);
          authenticationBloc.add(LoggedIn(token: token));
          emit(LoginInitial());
        } catch (error) {
          emit(LoginFailure(error: error.toString()));
        }
      },
    );
  }
}
