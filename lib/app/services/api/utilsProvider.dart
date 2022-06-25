import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sipelajar/app/data/model/api/updateInfoModel.dart';

import '../../helper/config.dart';

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
      print(e);
      throw Exception('Failed to load post');
    }
  }
}
