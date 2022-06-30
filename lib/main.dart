import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sipelajar/app/constant/theme.dart';
import 'package:sipelajar/app/services/connectivity/connectivity.dart';
import 'package:sipelajar/app/services/location/location.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  final storage = GetStorage();
  final token = storage.read('accestoken');
  HttpOverrides.global = MyHttpOverrides();
  await FlutterDownloader.initialize(
      debug:
          false, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  deleteFile();
  runApp(GetMaterialApp(
    enableLog: true,
    debugShowCheckedModeBanner: false,
    title: "Sipelajar",
    initialRoute: token == null ? '/login' : '/home',
    theme: appTheme,
    getPages: AppPages.routes,
  ));
  initServices();
}

void initServices() async {
  print('starting services ');
  await Get.putAsync<ConnectivityService>(() => ConnectivityService().init());

  print('All services started');
}

class Sipelajar extends StatefulWidget {
  const Sipelajar({Key? key}) : super(key: key);

  @override
  State<Sipelajar> createState() => _SipelajarState();
}

class _SipelajarState extends State<Sipelajar> {
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    final token = storage.read('accestoken');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sipelajar",
      initialRoute: token == null ? '/login' : '/home',
      theme: appTheme,
      getPages: AppPages.routes,
    );
  }
}

Future<void> deleteFile() async {
  final dir = await getExternalStorageDirectory();
  final file = File('${dir!.path}/Sipelajar.apk');
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    print(e);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
