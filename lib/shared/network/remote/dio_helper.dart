import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm/send',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> postData({
    required String url,
    required String to,
    required Map<String, dynamic> data,
    String lang = 'ar',
    String? token,
    Map<String, dynamic>? q,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? '',
    };
    return await dio!.post(
      url,
      data: data,
      queryParameters: q,
    );
  }
}
