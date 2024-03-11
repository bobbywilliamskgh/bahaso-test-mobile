import 'package:bobby/bloc/auth_bloc/auth.dart';
import 'package:bobby/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepositories userRepositories;
  final AuthenticationBloc authenticationBloc;

  RegisterBloc(
      {required this.userRepositories, required this.authenticationBloc})
      : super(RegisterInitial()) {
    on<RegisterButtonPressed>(
      (event, emit) async {
        emit(RegisterLoading());
        try {
          final token =
              await userRepositories.register(event.email, event.password);
          authenticationBloc.add(Registered(token: token));
          emit(RegisterSuccess());
        } catch (error) {
          emit(RegisterFailure(error: error.toString()));
        }
      },
    );
  }
}
