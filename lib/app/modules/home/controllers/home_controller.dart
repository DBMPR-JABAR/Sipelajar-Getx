import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sipelajar/app/data/model/api/newsResponseModel.dart';
import 'package:sipelajar/app/data/model/local/userModel.dart';
import 'package:sipelajar/app/helper/utils.dart';
import 'package:sipelajar/app/modules/home/component/newsDetail.dart';
import 'package:sipelajar/app/services/api/penangananProvider.dart';
import 'package:sipelajar/app/services/api/utilsProvider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../data/model/api/draftPenangananResponseModel.dart';
import '../../../data/model/local/entryLubangModel.dart';
import '../../../services/database/database.dart';
import 'package:restart_app/restart_app.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final storage = GetStorage();
  late TabController tabController;
  var isLoading = true.obs;
  var carouselList = <Widget>[].obs;

  var newsDataList = <NewsData>[].obs;
  bool enableSignOut = false;

  List<Widget> listTab = [
    const Tab(text: 'Sapu Lobang'),
    const Tab(text: 'Kemandoran')
  ];
  final ReceivePort _port = ReceivePort();
  var progres = 0.obs;
  DownloadTaskStatus statusDowload = DownloadTaskStatus.enqueued;
  var task = "".obs;
  var user = UserModel(name: '', email: '', password: '', role: '').obs;
  var version = "".obs;

  @override
  void onInit() {
    syncDatabase();
    getNewsData();
    getUserData();
    permisionFiles();
    tabController =
        TabController(length: listTab.length, vsync: this, initialIndex: 0);
    checkUpdate();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    isLoading.value = false;
    super.onInit();
  }

  void permisionFiles() async {
    var storage = await Permission.storage.request();
    var manageStorage = await Permission.manageExternalStorage.request();
    if (storage.isDenied) {
      showToast(
          'Beberapa fitur tidak dapat digunakan karena Anda tidak mengizinkan akses penyimpanan');
      await Permission.storage.request();
    }
    if (manageStorage.isDenied) {
      showToast(
          'Beberapa fitur tidak dapat digunakan karena Anda tidak mengizinkan akses penyimpanan');
      await Permission.manageExternalStorage.request();
    }
  }

  void syncDatabase() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    version.value = info.version;
    if (connection.connectionStatus.value) {
      await PenangananProvider.getDraftPenanganan().then((value) async {
        if (value == null) {
        } else {
          await DataPenanganFromServer.saveMany(value.dataPenanganan);
          showToast('Data berhasil disinkronisasi');
        }
      });
    }

    var dataPenanganan =
        await DataPenanganFromServer.getDataUpdated().then((value) {
      print(value);
      return value.length;
    });
    var dataLubang =
        await EntryLubangModel.getAllData().then((value) => value.length);

    if (dataPenanganan == 0 && dataLubang == 0) {
      enableSignOut = true;
    }
  }

  void getNewsData() async {
    await UtilsProvider.getNews().then((value) async {
      value == null ? null : newsDataList.value = value.data;
    });
    carouselList.value = newsDataList.map((e) => createWidget(e)).toList().obs;
  }

  getUserData() async {
    await UserModel.getUser().then((value) {
      if (value != null) {
        user.value = value;
      } else {
        showToast('Sesi anda telah berakhir, silahkan login kembali');
      }
      update();
    });
  }

  checkUpdate() async {
    await UtilsProvider.checkUpdate().then((value) => {
          if (value != null && enableSignOut)
            {
              Get.dialog(
                AlertDialog(
                  title: const Text('Update Tersedia'),
                  content: Text.rich(
                    TextSpan(
                      text: 'Update tersedia untuk versi ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: value.version,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' yang lebih baru.\n',
                          style: TextStyle(color: Colors.black),
                        ),
                        const TextSpan(
                          text: 'Apakah anda ingin mengupdate?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Update'),
                      onPressed: () {
                        Get.back();
                        download(value.url);
                      },
                    ),
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              )
            }
        });
  }

  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: (await getExternalStorageDirectory())!.path,
        showNotification: true,
        openFileFromNotification: false,
        fileName: 'Sipelajar.apk',
      );
      Get.dialog(Obx(
        () => AlertDialog(
          title: const Text('Downloading'),
          content: Text('$progres%'),
          actions: [
            progres.value == 100
                ? ElevatedButton(
                    onPressed: () {
                      open();
                    },
                    child: const Text('Update'))
                : ElevatedButton(
                    child: const Text('Batal'),
                    onPressed: () {
                      FlutterDownloader.cancel(taskId: task.value);
                      Get.back();
                    },
                  )
          ],
        ),
      ));
    } else {
      Get.snackbar(
        'Permission Denied',
        'Please grant storage permission to download the update',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        borderColor: Colors.red,
        borderWidth: 2,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @pragma('vm:entry-point')
  static downloadCallback(
      String id, DownloadTaskStatus status, int progress) async {
    SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  Future<void> open() async {
    OpenFile.open(
      '${(await getExternalStorageDirectory())!.path}/Sipelajar.apk',
    ).then((value) => {});
  }

  void retry(String id) {
    FlutterDownloader.retry(taskId: id);
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      progres.value = progress;
      statusDowload = status;
      task.value = taskId;
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  Container createWidget(NewsData data) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Stack(
            children: [
              InkWell(
                child: CachedNetworkImage(
                  imageUrl: data.pathUrl,
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.error);
                  },
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
                  fit: BoxFit.fill,
                  width: Get.width,
                  height: Get.height / 2.5,
                ),
                onTap: () {
                  Get.to(() => NewsDetail(
                        newsData: data,
                      ));
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    data.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )),
    );
  }

  void logout() async {
    var dataPenanganan =
        await DataPenanganFromServer.getDataUpdated().then((value) {
      return value.length;
    });
    var dataLubang =
        await EntryLubangModel.getAllData().then((value) => value.length);

    if (dataPenanganan == 0 && dataLubang == 0) {
      await storage.remove('accestoken');
      await DatabaseHelper.instance.truncateAllTable();
      Restart.restartApp();
    } else {
      showToast('Masih Ada Data Yang Belum Diupload');
    }
  }
}
