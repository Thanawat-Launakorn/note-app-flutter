part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final dynamic payload;
  LoginSuccess({ required this.payload });
}

final class LoginError extends LoginState {
  final dynamic payload;
  LoginError({ required this.payload });
}
