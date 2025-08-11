part of 'check_username_cubit.dart';

sealed class CheckUsernameState {}

final class CheckUsernameInitial extends CheckUsernameState {}

class IsLoadingCheckUsername extends CheckUsernameState {}

class ResponseDataCheckUsername extends CheckUsernameState {}

class ResponseErrorCheckUsername extends CheckUsernameState {
  final dynamic payload;
  ResponseErrorCheckUsername({required this.payload});
}
