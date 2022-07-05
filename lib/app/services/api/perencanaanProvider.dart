import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sipelajar/app/data/model/api/rencanaPenanganModel.dart';
import 'package:sipelajar/app/helper/utils.dart';

import '../../helper/config.dart';

class PerencanaanProvider {
  static final client = http.Client();
  static final storage = GetStorage();
  static final accestoken = storage.read('accestoken');

  static Future<RencanaPenanganModel> getPerencanaan(
      String ruasJlanId, String date) async {
    try {
      final response = await client
          .post(Config.listRencana,
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
      return rencanaPenanganModelFromJson(response.body);
    } catch (e) {
      print(e);
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      throw Exception('Terjadi kesalahan');
    }
  }

  static Future<String?> rejectLobang(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${Config.rejectLobang}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      ).timeout(const Duration(seconds: 5));
      var responseJson = json.decode(response.body);
      return responseJson['message'];
    } catch (e) {
      print(e);
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      throw Exception('Terjadi kesalahan');
    }
  }

  static Future<String?> jadwalLubang(
      String id, String date, String keterangan) async {
    try {
      final response = await client
          .post(
            Uri.parse('${Config.jadwalLubang}/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accestoken',
            },
            body: json.encode({
              'tanggal': date,
              'keterangan': keterangan,
            }),
          )
          .timeout(const Duration(seconds: 5));
      var responseJson = json.decode(response.body);
      return responseJson['message'];
    } catch (e) {
      print(e);
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      throw Exception('Terjadi kesalahan');
    }
  }
}
