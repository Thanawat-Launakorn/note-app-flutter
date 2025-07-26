import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ResponseAPI {
  final Dio _dio = Dio();
  Future process({
    required String endpoint,
    required dynamic body,
    dynamic headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: headers),
      );
      const debugAPI = true;
      if (debugAPI) {
        // debug
        debugPrint('body: $body');
        debugPrint('endpoint: $endpoint'); // endpoint
        debugPrint('payload: ${response.data}'); // payload
      }

      return response.data;
    } catch (e) {
      debugPrint('Error $endpoint $e');
      rethrow;
    }
  }
}
