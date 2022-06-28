import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class EntryDataLubangController extends GetxController {
  final Location location = Location();
  TextEditingController ruasJalan = TextEditingController();
  TextEditingController tanggal = TextEditingController();
  TextEditingController sta = TextEditingController();
  TextEditingController km1 = TextEditingController();
  TextEditingController km2 = TextEditingController();
  TextEditingController panjangLubang = TextEditingController();
  var lajur = ''.obs;
  var ukuran = ''.obs;
  var kedalaman = ''.obs;
  var potensi = ''.obs;
  TextEditingController keterangan = TextEditingController();
  late Future<void> initializeControllerFuture;
  var tglArgs = DateTime.parse(Get.arguments[1]);
  LocationData? locationData;
  var error = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getLocation();
    tanggal.text = DateFormat('dd-MM-yyyy').format(tglArgs).toString();
    ruasJalan.text =
        Get.arguments[0].namaRuasJalan + ' - ' + Get.arguments[0].idRuasJalan;
  }

  onLajurChange(var value) {
    lajur.value = value;
  }

  onUkuranChange(var value) {
    ukuran.value = value;
  }

  onKedalamanChange(var value) {
    kedalaman.value = value;
  }

  onPotensiChange(var value) {
    potensi.value = value;
  }

  Future<void> getLocation() async {
    error.value = '';
    isLoading.value = true;
    try {
      locationData = await location.getLocation();
      print(locationData);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        location.requestPermission();
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        location.requestPermission();
      }
      print(e.code);
    }
    isLoading.value = false;
  }
}
