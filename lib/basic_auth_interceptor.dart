import 'dart:convert';

import 'package:dio/dio.dart';

class BasicAuthInterceptor extends Interceptor {
  final String username;

  final String password;

  BasicAuthInterceptor({required this.username, required this.password});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    options.headers['Authorization'] = basicAuth;

    handler.next(options);
  }
}
