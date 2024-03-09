import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepositories {
  static String mainUrl = "https://reqres.in";
  var loginUrl = "${mainUrl}/api/login";

  final FlutterSecureStorage storage = FlutterSecureStorage();
  final Dio _dio = Dio();
}
