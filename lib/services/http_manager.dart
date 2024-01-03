import 'package:dio/dio.dart';

abstract class HttpMethods {
  static const String post = "POST";
  static const String get = "GET";
  static const String put = "PUT";
  static const String patch = "PATCH";
  static const String delete = "DELETE";
}

class HttpManager {
  Future restRequest(
      {required String url,
      required String method,
      Map? headers,
      Map? body}) async {
    final headersDefault = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
        'X-Parse-Application-Id': 'T0UpHXQz6Sa4KoL22t5Maro5dDGYUpkQNL5jR1Sg',
        'X-Parse-REST-API-Key': '2mgvScfJU7V0Eh7kb8K1S0S1dRjwwysjD8oleAs9',
      });

    Dio dio = Dio();

    try {
      Response response = await dio.request(url,
          options: Options(method: method, headers: headersDefault),
          data: body);
      return response.data;
    } on DioError catch (e) {
      return e.response?.data ?? {};
    } catch (e) {
      return {};
    }
  }
}
