import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultSurveiController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var dataLobang = Get.arguments[0];
  var dataPotensi = Get.arguments[1];
  String ruas = Get.arguments[2];
  String title = Get.arguments[3];
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
}
