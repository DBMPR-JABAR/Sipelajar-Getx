import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sipelajar/app/data/model/api/penangananResponseModel.dart';
import 'package:sipelajar/app/helper/utils.dart';

import '../../helper/config.dart';

class PenangananProvider {
  static final client = http.Client();
  static final storage = GetStorage();
  static final accestoken = storage.read('accestoken');

  static Future<PenanganResponseModel> getPenanganan(
      String ruasJlanId, String date) async {
    try {
      final response = await client
          .post(Config.listPenanganan,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $accestoken',
              },
              body: json.encode({
                'ruas_jalan_id': ruasJlanId,
                'tanggal': date,
              }))
          .timeout(const Duration(seconds: 5));

      return penanganResponseModelFromJson(response.body);
    } catch (e) {
      print(e);
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      throw Exception('Terjadi kesalahan');
    }
  }
}
