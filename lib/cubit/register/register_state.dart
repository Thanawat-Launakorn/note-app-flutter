part of 'register_cubit.dart';

sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

class isLoading extends RegisterState {}

class responseData extends RegisterState {}

class responseError extends RegisterState {}
