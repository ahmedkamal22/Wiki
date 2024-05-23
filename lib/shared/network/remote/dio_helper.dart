import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static getInit() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://fcm.googleapis.com/fcm/",
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String key,
    Map<String, dynamic>? query,
    String lang = "en",
    String? token,
  }) async {
    dio!.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization": token
    };
    return await dio!.get(key, queryParameters: query);
  }

  static Future<Response> postData({
    required String key,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = "en",
  }) async {
    dio!.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization":
          "key=AAAAy1Rwvxg:APA91bED_VZE9Cb2cKtHrJuoXnulkHEdn6VydMrsvPadYkOE0Rghg9WWZZ44MQTatheajy226h-kX34tctOumdRzA6lOulS-XNTPKYcnZivC-9xYJ9mKI7Q3_5p8ve56kK4Ebc0MZIct",
    };
    return await dio!.post(key, data: data, queryParameters: query);
  }

  static Future<Response> putData({
    required String key,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = "en",
    String? token,
  }) async {
    dio!.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization": token
    };
    return await dio!.put(key, queryParameters: query, data: data);
  }
}
