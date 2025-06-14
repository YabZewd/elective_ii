part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthSignupRequested extends AuthEvent {
  final String userName;
  final String email;
  final String password;

  AuthSignupRequested(
      {required this.userName, required this.email, required this.password});
}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

final class AuthLogoutRequested extends AuthEvent {}
