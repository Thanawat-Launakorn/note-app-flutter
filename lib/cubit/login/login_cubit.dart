import 'dart:convert';
import 'package:app/util/device.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void postLogin({
    required String endpoint,
    required Map<dynamic, dynamic> body
  }) async {
    emit(LoginLoading());
    debugPrint('emitted: LoginLoading');
    final http.Response response = await http.post(Uri.parse(endpoint),
      headers: {
        'device_id': await getDeviceId(),
        'device_type': await getDeviceType(),
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body)
    );

    try {
      debugPrint('response: ${response.statusCode}');
      debugPrint('response: ${response.body}');
      final dynamic payload = json.decode(response.body);
      if (payload['status'] == '200') {
        emit(LoginSuccess(payload: payload));
        debugPrint('emitted: LoginSuccess');
      } else {
        emit(LoginError(payload: payload));
        debugPrint('emitted: LoginError');

      }

    } catch (e) {
      throw Exception('Error $e');
    }

  }
}
