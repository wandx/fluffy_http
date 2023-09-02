import 'package:chopper/chopper.dart';
import 'package:fluffy_core/fluffy_core.dart';
import 'package:fluffy_http/src/fluffy_http_env.dart';
import 'package:fluffy_http/src/interceptors/auth_request_interceptor.dart';
import 'package:fluffy_http/src/interceptors/response_error_interceptor.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

/// Fluffy Http class
class FluffyHttp {
  FluffyHttp._();

  static final FluffyHttp _instance = FluffyHttp._();

  /// Fluffy Http Singleton
  static FluffyHttp get instance => _instance;

  /// current default response error interceptor
  ResponseInterceptor responseErrorInterceptor = ResponseErrorInterceptor();

  /// Set Token
  Future<void> setToken(String token) async {
    await SecureSharedPref.getInstance().then((value) async {
      await value.putString(
        FluffyHttpEnv.tokenKey,
        token,
        isEncrypted: true,
      );
    });
  }

  /// Get Token
  Future<String?> getToken() async {
    final prefs = await SecureSharedPref.getInstance();
    final token = await prefs.getString(FluffyHttpEnv.tokenKey);
    return token;
  }

  /// Package level base url
  String? baseUrl;

  /// List of chopper service with auth header
  final List<ChopperService> _authServices = [];

  /// List of chopper service
  final List<ChopperService> _services = [];

  /// Register service to authServices list
  void registerAuthService(ChopperService service) =>
      _authServices.add(service);

  /// Register service to services list
  void registerService(ChopperService service) => _services.add(service);

  /// Authenticated Chopper Client
  ChopperClient get authClient {
    final bu = baseUrl ?? FluffyCore.instance.baseUrl ?? '';
    return ChopperClient(
      baseUrl: Uri.parse(bu),
      services: _authServices,
      converter: const JsonConverter(),
      interceptors: [
        ResponseErrorInterceptor(),
        HttpLoggingInterceptor(),
        AuthRequestInterceptor(),
        const HeadersInterceptor({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      ],
    );
  }

  /// Authenticated Chopper Client with custom base url
  ChopperClient authClientWithBaseUrl(
    String customBaseUrl, {
    String? customToken,
  }) {
    return ChopperClient(
      baseUrl: Uri.parse(customBaseUrl),
      services: _authServices,
      converter: const JsonConverter(),
      interceptors: [
        ResponseErrorInterceptor(),
        HttpLoggingInterceptor(),
        AuthRequestInterceptor(customToken: customToken),
        const HeadersInterceptor({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      ],
    );
  }

  /// Chopper Client
  ChopperClient get client {
    final bu = baseUrl ?? FluffyCore.instance.baseUrl ?? '';
    return ChopperClient(
      baseUrl: Uri.parse(bu),
      services: _services,
      converter: const JsonConverter(),
      interceptors: [
        ResponseErrorInterceptor(),
        HttpLoggingInterceptor(),
        const HeadersInterceptor({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      ],
    );
  }

  /// Chopper Client with custom base url
  ChopperClient clientWithBaseUrl(String customBaseUrl) {
    return ChopperClient(
      baseUrl: Uri.parse(customBaseUrl),
      services: _services,
      converter: const JsonConverter(),
      interceptors: [
        ResponseErrorInterceptor(),
        HttpLoggingInterceptor(),
        const HeadersInterceptor({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      ],
    );
  }
}
