import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile/services/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
final AuthRepository authRepository = AuthRepository();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);

    on<AuthSignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signup(
            event.userName, event.email, event.password);
        add(AuthLoginRequested(email: event.email, password: event.password));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _secureStorage.delete(key: 'jwt_token');
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }

  Future<void> _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    final email = event.email;
    final password = event.password;

    emit(AuthLoading());

    try {
      final credentials = await authRepository.login(email, password);
      await _secureStorage.write(key: 'jwt_token', value: credentials['token']);
      emit(AuthSuccess(
          uid: credentials['uid'],
          email: credentials['email'],
          userName: credentials['userName']));
    } catch (e) {
      emit(AuthFailure(
          e.toString().replaceFirst('Exception: ', 'couldn\'t login, $e')));
    }
  }
}
