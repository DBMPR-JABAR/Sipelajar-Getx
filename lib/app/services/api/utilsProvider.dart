import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sipelajar/app/data/model/api/updateInfoModel.dart';
import 'package:sipelajar/app/services/connectivity/connectivity.dart';

import '../../data/model/api/newsResponseModel.dart';
import '../../helper/config.dart';
import '../../helper/utils.dart';

final connection = Get.find<ConnectivityService>();

class UtilsProvider {
  static final client = http.Client();

  static Future<UpdateInfoModel?> checkUpdate() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    try {
      final response =
          await client.get(Uri.parse('${Config.baseUrl}/app/version'));
      final data = json.decode(response.body);
      final version = data['version'];
      if (version != info.version) {
        return UpdateInfoModel.fromJson(data);
      }
      return null;
    } catch (e) {
      if (e is SocketException) {
        connection.connectionStatus.value = false;
        showToast('Tidak ada koneksi internet');
      }
      return null;
    }
  }

//https://geo.temanjabar.net/geoserver/gsr/services/temanjabar/FeatureServer/0
  static Future<List<LatLng>> getPolyline(String id) async {
    try {
      final response = await client.get(Uri.parse(
          "https://geo.temanjabar.net/geoserver/wfs?service=wfs&version=2.0.0&request=GetFeature&typeName=temanjabar:0_rj_prov_v&outputFormat=application/json&CQL_FILTER=idruas='$id'"));
      final data = json.decode(response.body);
      final features = data['features'][0]['geometry']['coordinates'][0];
      List<LatLng> list = [];

      for (var i = 0; i < features.length; i++) {
        list.add(LatLng(features[i][1], features[i][0]));
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<String> ping() async {
    try {
      final response = await client
          .get(Uri.parse('https://youtube.com'))
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw Exception('Timeout'));

      return '${response.statusCode}';
    } on TimeoutException catch (_) {
      return 'timeout';
    } on SocketException catch (_) {
      return 'no internet';
    } on Exception catch (_) {
      return 'error';
    }
  }

  static Future<NewsResponseModel?> getNews() async {
    try {
      final response = await client.get(Config.listNews);
      final data = json.decode(response.body);
      return NewsResponseModel.fromJson(data);
    } catch (e) {
      if (e is SocketException) {
        connection.connectionStatus.value = false;
      }
      return null;
    }
  }
}
