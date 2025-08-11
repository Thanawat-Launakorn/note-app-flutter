import 'package:app/helpers/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:app/helpers/response_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future postLogin(FetchAPI request) async {
    emit(LoginLoading());
    debugPrint('emitted: LoginLoading');
    try {
      final payload = await ResponseAPI().process(request);
      if (payload['status'] != '200') {
        emit(LoginError(payload: payload));
      } else {
        await SharedPreferencesHelpers.setPrefs(
          'authorization',
          payload['data']['access_token'],
        );

        emit(LoginSuccess(payload: payload));
      }
    } catch (err) {
      debugPrint('error: $err');
    }
  }
}
