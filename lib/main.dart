import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sipelajar/app/constant/theme.dart';
import 'package:sipelajar/app/helper/fcm.dart';

import 'app/routes/app_pages.dart';
import 'app/services/connectivity/connectivity.dart';
import 'app/services/database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  FCM().setNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await DatabaseHelper.instance.database.then((value) => print(value));
  await Get.putAsync<ConnectivityService>(() => ConnectivityService().init());
  HttpOverrides.global = MyHttpOverrides();
  await FlutterDownloader.initialize(
      debug:
          false, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  deleteFile();
  runApp(const Sipelajar());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification!.title}");
}

class Sipelajar extends StatefulWidget {
  const Sipelajar({Key? key}) : super(key: key);

  @override
  State<Sipelajar> createState() => _SipelajarState();
}

class _SipelajarState extends State<Sipelajar> {
  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
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
  } catch (_) {}
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
