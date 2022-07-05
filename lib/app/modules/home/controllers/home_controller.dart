import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sipelajar/app/data/model/local/userModel.dart';
import 'package:sipelajar/app/helper/utils.dart';
import 'package:sipelajar/app/services/api/utilsProvider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../services/database/database.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final storage = GetStorage();
  late TabController tabController;
  List<String> carouselData = [
    'https://tj.temanjabar.net/storage/50/WhatsApp-Image-2022-06-23-at-12.18.00.jpeg',
    'https://tj.temanjabar.net/storage/49/WhatsApp-Image-2022-06-17-at-15.48.27-(4).jpeg',
    'https://tj.temanjabar.net/storage/48/WhatsApp-Image-2022-06-17-at-15.46.39.jpeg',
    'https://tj.temanjabar.net/storage/46/WhatsApp-Image-2022-06-09-at-13.08.32.jpeg',
    'https://tj.temanjabar.net/storage/43/WhatsApp-Image-2022-06-03-at-09.37.10.jpeg',
    'https://tj.temanjabar.net/storage/25/Morning-Routine-Neutral-Photo-Collage.png',
  ];
  var carouselList = <Widget>[].obs;
  var isLoading = true.obs;

  List<Widget> listTab = [
    const Tab(text: 'Sapu Lobang'),
    const Tab(text: 'Kemandoran')
  ];
  final ReceivePort _port = ReceivePort();
  var progres = 0.obs;
  DownloadTaskStatus statusDowload = DownloadTaskStatus.enqueued;
  var task = "".obs;
  late UserModel? userModel;

  @override
  void onInit() {
    permisionFiles();
    tabController =
        TabController(length: listTab.length, vsync: this, initialIndex: 0);
    checkUpdate();
    _bindBackgroundIsolate();
    getUser();
    createWidgetCarousel();
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

  getUser() async {
    userModel = await UserModel.getUser();
    update();
  }

  checkUpdate() async {
    await UtilsProvider.checkUpdate().then((value) => {
          if (value != null)
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

  void createWidgetCarousel() {
    carouselList = carouselData.map((e) => createWidget(e)).toList().obs;
  }

  Container createWidget(dynamic data) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Stack(
            children: [
              InkWell(
                child: CachedNetworkImage(
                  imageUrl: data,
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
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'dummy text',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )),
    );
  }

  logout() async {
    await storage.erase();
    await DatabaseHelper.instance.truncateAllTable();
    Get.offAllNamed('/login');
  }
}
