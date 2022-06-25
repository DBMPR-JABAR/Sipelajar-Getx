import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sipelajar/app/data/model/local/usermodel.dart';
import 'package:sipelajar/app/services/api/utilsProvider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  List<String> carouselData = [
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
  ];
  var carouselList = <Widget>[].obs;

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
    tabController =
        TabController(length: listTab.length, vsync: this, initialIndex: 0);
    checkUpdate();
    _bindBackgroundIsolate();
    getUser();
    createWidgetCarousel();

    FlutterDownloader.registerCallback(downloadCallback);

    super.onInit();
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

  void permision() {
    var storage = Permission.storage.request();
    var location = Permission.location.request();
    Future.wait([storage, location]).then((value) => {
          if (value.contains(PermissionStatus.granted))
            {Get.offNamed('/login')}
          else
            {
              Get.snackbar('Permission Denied', 'Please grant permission',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  icon: Icon(Icons.error))
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
    ).then((value) => {
          print(value.type),
        });
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

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );
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
                  height: Get.height / 3,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'dummy text',
                    style: const TextStyle(
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
}
