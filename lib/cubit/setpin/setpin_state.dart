part of 'setpin_cubit.dart';

sealed class SetpinState {}

final class SetpinInitial extends SetpinState {}

class IsLoadingSetPin extends SetpinState {}

class ResponseDataSetPin extends SetpinState {}

class ResponseErrorSetPin extends SetpinState {
  final dynamic payload;
  ResponseErrorSetPin({required this.payload});
}
