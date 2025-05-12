part of 'login_bloc.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

class isLoading extends LoginState {}

class responseData extends LoginState {}

class responseError extends LoginState {}
