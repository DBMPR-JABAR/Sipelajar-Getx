import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sipelajar/app/data/model/api/draftPenangananResponseModel.dart';
import 'package:sipelajar/app/data/model/api/penangananResponseModel.dart';
import 'package:sipelajar/app/helper/utils.dart';

import '../../helper/config.dart';

class PenangananProvider {
  static final client = http.Client();
  static final storage = GetStorage();
  static final accestoken = storage.read('accestoken');

  static Future<PenanganResponseModel?> getPenanganan(
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
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      return null;
    }
  }

  static Future<String?> penangananLubang(
    Map<String, String> body,
    XFile? img,
    int id,
    String date,
  ) async {
    try {
      var fileImg = await http.MultipartFile.fromPath(
          'image_penanganan', img!.path,
          contentType: MediaType('image', 'jpg'));
      final request = http.MultipartRequest(
          'POST', Uri.parse('${Config.excutePenanganan}/$id/$date'))
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        })
        ..fields.addAll(body)
        ..files.add(fileImg);
      final response = await request.send().timeout(const Duration(seconds: 20),
          onTimeout: () => throw Exception('Timeout'));
      final responseData = await response.stream.bytesToString();
      final resJson = json.decode(responseData);
      if (resJson['message'] == "Berhasil Merubah Status Lubang") {
        return 'success';
      } else {
        return resJson['data']['error'];
      }
    } catch (e) {
      print(e);
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      return 'false';
    }
  }

  static Future<DraftPenanganFromServer?> getDraftPenanganan() async {
    try {
      final response = await client.get(
        Config.listDraftPenanganan,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      );

      return draftPenanganFromServerFromJson(response.body);
    } catch (e) {
      print(e);
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      return null;
    }
  }
}
