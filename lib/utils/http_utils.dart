import 'package:dio/dio.dart';

class HttpUtils {
  static final Dio dio = Dio();

  static Future<Response<dynamic>?> get(String path) async {
    try {
      var response = await dio.get(path);
      return response;
    } catch (error) {
      return null;
    }
  }

  static Future<Response<dynamic>?> post(String path, data) async {
    try {
      var response = await dio.post(path, data: data);
      return response;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
