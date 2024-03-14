import 'package:bobby/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepositories userRepositories;
  AuthenticationBloc({required this.userRepositories})
      : super(AuthenticationUnauthenticated()) {
    on<AppStarted>((event, emit) async {
      final bool hasToken = await userRepositories.hasToken();
      if (hasToken) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationLoading());
      await userRepositories.persistToken(event.token);
      await userRepositories.persistEmail(event.email);
      emit(AuthenticationAuthenticated());
    });

    on<Registered>((event, emit) async {
      emit(AuthenticationLoading());
      emit(AuthenticationUnauthenticated());
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthenticationLoading());
      await userRepositories.deleteToken();
      emit(AuthenticationUnauthenticated());
    });
  }
}
