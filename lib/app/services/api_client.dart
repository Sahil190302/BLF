import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'api_urls.dart';

class ApiClient {

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseurl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static String? token;

  // Initialize Interceptors
  static void init() {
    dio.interceptors.clear();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("=========== API REQUEST ===========");
          print("URL → ${options.baseUrl}${options.path}");
          print("METHOD → ${options.method}");
          print("HEADERS → ${options.headers}");
          print("BODY → ${options.data}");
          print("===================================");

          handler.next(options);
        },

        onResponse: (response, handler) {
          print("=========== API RESPONSE ===========");
          print("URL → ${response.requestOptions.uri}");
          print("STATUS → ${response.statusCode}");
          print("DATA → ${response.data}");
          print("====================================");

          handler.next(response);
        },

        onError: (error, handler) {
          print("=========== API ERROR ===========");
          print("URL → ${error.requestOptions.uri}");
          print("MESSAGE → ${error.message}");
          print("RESPONSE → ${error.response?.data}");
          print("=================================");

          handler.next(error);
        },
      ),
    );
  }

  // ===========================
  // POST METHOD
  // ===========================
  static Future<dynamic> post(
      Map<String, dynamic> data, {
        bool isAuthRequired = false,
      }) async {
    try {

      final options = Options();

      // Optional Authorization Header
      if (isAuthRequired && token != null) {
        options.headers = {
          "Authorization": token,
        };
      }

      final response = await dio.post(
        "",
        data: data,
        options: options,
      );

      return response.data;

    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?["message"] ?? "Server Error",
      );
    }
  }

  // ===========================
  // GET METHOD
  // ===========================
  static Future<dynamic> get(
      String url, {
        bool isAuthRequired = false,
      }) async {
    try {

      final options = Options();

      // Optional Authorization Header
      if (isAuthRequired && token != null) {
        options.headers = {
          "Authorization": token,
        };
      }

      final response = await dio.get(
        url,
        options: options,
      );

      return response.data;

    } on DioException catch (e) {
      throw ApiException(
        e.response?.data?["message"] ?? "Server Error",
      );
    }
  }

}
