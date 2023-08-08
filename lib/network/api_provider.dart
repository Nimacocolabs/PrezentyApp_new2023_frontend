import 'package:dio/dio.dart';
import 'package:event_app/network/api_interceptor.dart';
import 'package:event_app/util/app_helper.dart';

class ApiProvider {
  Dio? _dio;

  static String baseUrl = isProduction
      ? 'https://www.prezenty.in/prezenty/api/web/v1/' //live
      : 'https://www.prezenty.in/prezenty-test/api/web/v1/'; //staging

  ApiProvider() {
    BaseOptions options;
    options = new BaseOptions(
      baseUrl: baseUrl,

      // receiveTimeout: 10000,
      // connectTimeout: 10000,
    );

    _dio = Dio(options);
    _dio!.interceptors.add(ApiInterceptor());
  }

  Dio getJsonInstance() {
    _dio!.options.headers.addAll({"Content-Type": "application/json"});
    return _dio!;
  }

  Dio getMultipartInstance() {
    _dio!.options.headers.addAll({"Content-Type": "multipart/form-data"});
    return _dio!;
  }

  Dio getJsonInstanceAuth(token) {
    _dio!.options.baseUrl = 'http://prezentystore.com/backend/web/1/';
    _dio!.options.headers.addAll({
      "authorization": "Bearer  $token",
    });
    return _dio!;
  }

  Dio getJsonInstanceWoohoo(token) {
    _dio!.options.baseUrl = baseUrl;
    _dio!.options.headers.addAll({
      "authorization": "Bearer  $token",
    });
    return _dio!;
  }

  Dio getJsonInstanceStatus(token) {
    _dio!.options.baseUrl = 'http://prezentystore.com/backend/web/1/';
    _dio!.options.headers.addAll({
      "authorization": "Bearer  $token",
    });
    return _dio!;
  }

  Dio getJsonInstancedetails(token) {
    _dio!.options.baseUrl = 'http://prezentystore.com/backend/web/1/';
    _dio!.options.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    return _dio!;
  }
}
