import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart' as laucher_maps;
import 'package:sipelajar/app/services/connectivity/connectivity.dart';
import 'package:sipelajar/app/services/location/location.dart';

import '../../../../../services/api/utilsProvider.dart';

class EntryDataLubangController extends GetxController {
  final locationService = Get.find<LocationService>();
  final connectionService = Get.find<ConnectivityService>();
  TextEditingController ruasJalan = TextEditingController();
  TextEditingController tanggal = TextEditingController();
  TextEditingController sta = TextEditingController();
  TextEditingController km1 = TextEditingController();
  TextEditingController km2 = TextEditingController();
  TextEditingController panjangLubang = TextEditingController();
  late MapController mapsController;
  var address = ''.obs;
  var polyline = <LatLng>[].obs;
  var currentLocation = LatLng(0, 0).obs;
  var interActiveFlags = InteractiveFlag.all;
  StreamSubscription<LocationData>? listenLocation;
  LocationData? currentLocationData;
  var image = XFile('').obs;

  var lajur = ''.obs;
  var ukuran = ''.obs;
  var kedalaman = ''.obs;
  var potensi = ''.obs;

  TextEditingController keterangan = TextEditingController();

  var tglArgs = DateTime.parse(Get.arguments[1]);
  var isLoading = true.obs;

  @override
  void onInit() {
    mapsController = MapController();
    tanggal.text = DateFormat('dd-MM-yyyy').format(tglArgs).toString();
    ruasJalan.text =
        Get.arguments[0].namaRuasJalan + ' - ' + Get.arguments[0].idRuasJalan;
    getDataMaps(Get.arguments[0].idRuasJalan);
    checkLocationService();
    super.onInit();
  }

  checkLocationService() async {
    var serviceEnabled = await locationService.location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.location.requestService();
      if (!serviceEnabled) {
        serviceEnabled = await locationService.location.serviceEnabled();
      }
    }
    currentLocationData = await locationService.location.getLocation();
    currentLocation.value =
        LatLng(currentLocationData!.latitude!, currentLocationData!.longitude!);
    await locationService
        .getAdrres(
            currentLocation.value.latitude, currentLocation.value.longitude)
        .then((value) {
      address.value = value;
    });
    onTapCenter();
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

  void onTapCenter() async {
    currentLocationData = await locationService.location.getLocation();
    currentLocation.value =
        LatLng(currentLocationData!.latitude!, currentLocationData!.longitude!);
    mapsController.moveAndRotate(currentLocation.value, 18, 0);
    await locationService
        .getAdrres(
            currentLocation.value.latitude, currentLocation.value.longitude)
        .then((value) {
      print(value);
      address.value = value;
    });
  }

  getDataMaps(String id) async {
    polyline.value = await UtilsProvider.getPolyline(id);
  }

  openGoogleMaps() {
    locationService.availableMaps.first.showMarker(
        coords: laucher_maps.Coords(
            currentLocation.value.latitude, currentLocation.value.longitude),
        title: 'Lokasi Saat Ini Sudah Sesuai ?',
        description: address.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    listenLocation?.cancel();
    super.onClose();
  }

  onImageChange(value) {
    print(value);
    image.value = value;
  }

  validate() {
    if (sta.text.isEmpty) {
      Get.snackbar('Error', 'STA Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (km1.text.isEmpty) {
      Get.snackbar('Error', 'KM1 Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (km2.text.isEmpty) {
      Get.snackbar('Error', 'KM2 Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (panjangLubang.text.isEmpty) {
      Get.snackbar('Error', 'Panjang Lubang Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (lajur.value == '') {
      Get.snackbar('Error', 'Lajur Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (ukuran.value == '') {
      Get.snackbar('Error', 'Ukuran Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (kedalaman.value == '') {
      Get.snackbar('Error', 'Kedalaman Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (potensi.value == '') {
      Get.snackbar('Error', 'Potensi Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (keterangan.text.isEmpty) {
      Get.snackbar('Error', 'Keterangan Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (image.value.path == '') {
      Get.snackbar('Error', 'Foto Belum Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (currentLocationData == null) {
      Get.snackbar('Error', 'Belum Mendapatkan Lokasi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (currentLocationData!.accuracy! > 50) {
      Get.snackbar('Error', 'Lokasi Tidak Akurat',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (currentLocationData!.isMock!) {
      Get.snackbar('Error', 'Anda Terdeteksi Menggunakan Lokasi Palsu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else {
      return true;
    }
  }
}
