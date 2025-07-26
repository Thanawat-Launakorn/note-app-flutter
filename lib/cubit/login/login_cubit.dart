import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/helpers/response_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Dio _dio = Dio();

  LoginCubit() : super(LoginInitial());

  Future postLogin({
    required String endpoint,
    required Map<dynamic, dynamic> body,
  }) async {
    emit(LoginLoading());
    debugPrint('emitted: LoginLoading');

    final payload = await ResponseAPI().process(endpoint: endpoint, body: body);

    if (payload['status'] != '200') {
      emit(LoginError(payload: payload));
    } else {
      emit(LoginSuccess(payload: payload));
    }
  }
}
