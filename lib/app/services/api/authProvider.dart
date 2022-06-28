import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sipelajar/app/data/model/api/loginResponseModel.dart';

import '../../helper/config.dart';

class AuthProvider {
  static final client = http.Client();
  static final storage = GetStorage();
  static final accestoken = storage.read('accestoken');

  static Future<LoginResponModel> login(
      String username, String password) async {
    try {
      final response = await client.post(Config.loginUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'email': username,
            'password': password,
          }));
      return loginResponModelFromJson(response.body);
    } catch (e) {
      throw Exception('Terjadi kesalahan');
    }
  }
}
