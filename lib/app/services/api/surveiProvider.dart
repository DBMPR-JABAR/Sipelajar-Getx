import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sipelajar/app/data/model/api/startSurverResponModel.dart';

import '../../helper/config.dart';

class SurveiProvider {
  static final client = http.Client();
  static final storage = GetStorage();
  static final accestoken = storage.read('accestoken');

  static Future<StartSurveiResponModel> startSurvei(
      String ruasId, String tgl) async {
    try {
      final response = await client.post(Config.startSurvei,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accestoken',
          },
          body: json.encode({
            'ruas_jalan_id': ruasId,
            'tanggal': tgl,
          }));
      print(json.decode(response.body)['data']);
      return startSurveiResponModelFromJson(response.body);
    } catch (e) {
      print(e);
      throw Exception('Terjadi kesalahan');
    }
  }
}
