import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sipelajar/app/helper/utils.dart';
import 'package:sipelajar/app/services/api/surveiProvider.dart';

import '../../../../../data/model/local/entryLubangModel.dart';

class ResultSurveiController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var dataLobang = Get.arguments[0];
  var dataPotensi = Get.arguments[1];
  String ruas = Get.arguments[2];
  String title = Get.arguments[3];
  String ruasId = Get.arguments[4];
  String date = Get.arguments[5];
  late TabController tabController;
  List<Widget> listTab = [
    const Tab(text: 'Lubang'),
    const Tab(text: 'Potensi')
  ];

  @override
  void onInit() {
    tabController =
        TabController(length: listTab.length, vsync: this, initialIndex: 0);
    super.onInit();
  }

  void deleteLobang(int id) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Apakah anda yakin ingin menghapus data ini?'),
        actions: [
          ElevatedButton(
            child: const Text('Tidak'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: () async {
              if (title == 'Offline') {
                await EntryLubangModel.delete(id).then((value) => Get.back());
                Get.back();
                showToast('Data berhasil dihapus');
              } else {
                await SurveiProvider.deleteLubang(id).then((value) {
                  if (value != null) {
                    Get.back();
                    Get.back();
                    showToast('Data berhasil dihapus');
                  }
                });
              }
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  void getDataDb() async {
    await EntryLubangModel.getallPotensiLubang(ruasId).then((value) {
      dataPotensi = value;
    });
    await EntryLubangModel.getAllLubang(ruasId).then((value) {
      dataLobang = value;
    });
  }

  void getDataApi() async {
    await SurveiProvider.resultSurvei(ruasId, date).then((value) {
      dataPotensi = value?.data.surveiPotensiLubangDetail ?? [];
      dataLobang = value?.data.surveiLubangDetail ?? [];
    });
  }
}
