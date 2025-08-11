import 'dart:convert';

import 'package:app/helpers/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum METHOD { get, post }

class FetchAPI {
  final String endpoint;
  final dynamic body;
  final dynamic headers;
  final METHOD methodAPI;

  FetchAPI({
    this.methodAPI = METHOD.post,
    this.headers,
    required this.endpoint,
    this.body,
  });

  @override
  String toString() {
    return 'FetchAPI(endpoint: $endpoint, methodAPI: ${methodAPI.toString().split('.').last}, headers: $headers, body: $body)';
  }
}

class ResponseAPI {
  Future process(FetchAPI request) async {
    try {
      dynamic response;

      switch (request.methodAPI) {
        case METHOD.get:
          response = await http.get(
            Uri.parse(request.endpoint),
            headers: {
              'Content-Type': 'application/json',
              'authorization':
                  await SharedPreferencesHelpers.getPrefs('authorization')
                      as String,
            },
          );
          break;
        case METHOD.post:
          response = await http.post(
            Uri.parse(request.endpoint),
            body: jsonEncode(request.body),
            headers: {
              'Content-Type': 'application/json',
              'authorization':
                  await SharedPreferencesHelpers.getPrefs('authorization')
                      as String,
            },
          );
          break;
      }

      const debugAPI = true;
      if (debugAPI) {
        // debug
        debugPrint('body: ${request.body}');
        debugPrint('endpoint: ${request.endpoint}'); // endpoint
        debugPrint('payload: ${response.body}'); // payload
      }
      final payload = jsonDecode(response.body);
      return payload;
    } catch (e) {
      debugPrint('Error ${request.endpoint} $e');
      rethrow;
    }
  }
}
