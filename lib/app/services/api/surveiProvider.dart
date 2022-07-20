import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sipelajar/app/data/model/api/rekapResponseModel.dart';
import 'package:sipelajar/app/data/model/api/startSurverResponModel.dart';
import 'package:sipelajar/app/helper/utils.dart';
import '../../data/model/api/rekapLubangResponseModel.dart';
import '../../data/model/api/resultSurveiModel.dart';
import '../../helper/config.dart';
import 'package:http_parser/http_parser.dart';

class SurveiProvider {
  static final client = http.Client();
  static final storage = GetStorage();
  static final accestoken = storage.read('accestoken');

  static Future<StartSurveiResponModel?> startSurvei(
      String ruasId, String tgl) async {
    try {
      final response = await client
          .post(Config.startSurvei,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $accestoken',
              },
              body: json.encode({
                'ruas_jalan_id': ruasId,
                'tanggal': tgl,
              }))
          .timeout(const Duration(seconds: 5));
      return startSurveiResponModelFromJson(response.body);
    } catch (e) {
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      return null;
    }
  }

  static Future<ResultSurveiResponseModel?> resultSurvei(
      String ruasJalanId, String tanggal) async {
    try {
      final response = await client
          .post(Config.resultSurvei,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $accestoken',
              },
              body: json.encode({
                'ruas_jalan_id': ruasJalanId,
                'tanggal': tanggal,
              }))
          .timeout(const Duration(seconds: 5));

      return resultSurveiResponseModelFromJson(response.body);
    } catch (e) {
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      return null;
    }
  }

  static Future<String> storeSurvei(
      Map<String, String> body, XFile? img) async {
    try {
      var fileImg = await http.MultipartFile.fromPath('image', img!.path,
          contentType: MediaType('image', 'jpg'));
      final request = http.MultipartRequest('POST', Config.storeSurvei)
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

      if (resJson['message'] == "Berhasil Menambahkan") {
        return 'success';
      } else {
        return resJson['data']['error'];
      }
    } catch (e) {
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');

      return 'false';
    }
  }

  static Future<RekapResponseModel?> rekapSurvei() async {
    try {
      final response = await client.get(
        Config.rekapData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      ).timeout(const Duration(seconds: 5));

      return rekapResponseModelFromJson(response.body);
    } catch (e) {
      print(e);
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      return null;
    }
  }

  static Future<RekapLubangResponseModel?> rekapLobang() async {
    try {
      final response = await client.get(
        Config.rekapLubang,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      );
      return rekapLubangResponseModelFromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  static Future<RekapLubangResponseModel?> rekapPotensi() async {
    try {
      final response = await client.get(
        Config.rekapPotensi,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      );
      return rekapLubangResponseModelFromJson(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<RekapLubangResponseModel?> rekapPerencanaan() async {
    try {
      final response = await client.get(
        Config.rekapDalamPerencanaan,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      );
      return rekapLubangResponseModelFromJson(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<RekapLubangResponseModel?> rekapPenanganan() async {
    try {
      final response = await client.get(
        Config.rekapSelesai,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      );
      return rekapLubangResponseModelFromJson(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> deleteLubang(int id) async {
    try {
      final response = await client.get(
        Uri.parse('${Config.deleteLubang}/ $id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      ).timeout(const Duration(seconds: 5));

      return response.body;
    } catch (e) {
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      return null;
    }
  }

  static Future<String?> deletePotensiLubang(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${Config.deletePotensiLubang}/ $id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accestoken',
        },
      ).timeout(const Duration(seconds: 5));

      return response.body;
    } catch (e) {
      showToast('Tidak ada Koneksi Internet / Internet Tidak Stable');
      return null;
    }
  }
}
