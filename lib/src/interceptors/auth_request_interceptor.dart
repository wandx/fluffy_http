import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:fluffy_http/fluffy_http.dart';

/// Auth Response Interceptor
class AuthRequestInterceptor implements RequestInterceptor {
  /// Constructor
  AuthRequestInterceptor({
    this.customToken,
  });

  /// Override current token
  final String? customToken;

  @override
  FutureOr<Request> onRequest(Request request) async {
    final token = await FluffyHttp.instance.getToken();
    return applyHeaders(
        request, {'Authorization': 'Bearer ${customToken ?? token}'});
  }

  /// Apply current headers
  Request applyHeaders(
    Request request,
    Map<String, String> headers, {
    bool override = true,
  }) {
    final h = Map<String, String>.from(request.headers);

    for (final k in headers.keys) {
      if (!override && h.containsKey(k)) continue;
      h[k] = headers[k] ?? '';
    }

    return request.copyWith(headers: h);
  }
}
