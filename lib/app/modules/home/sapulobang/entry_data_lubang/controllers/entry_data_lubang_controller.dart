import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart' as laucher_maps;
import 'package:permission_handler/permission_handler.dart'
    as permision_handler;
import 'package:sipelajar/app/data/model/local/entryLubangModel.dart';
import 'package:sipelajar/app/services/connectivity/connectivity.dart';
import 'package:sipelajar/app/services/location/location.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../services/api/surveiProvider.dart';
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
  TextEditingController jumlahLubang = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  late MapController mapsController;
  var address = ''.obs;
  var polyline = <LatLng>[].obs;
  var currentLocation = LatLng(0, 0).obs;
  var interActiveFlags = InteractiveFlag.all;
  Position? currentLocationData;
  var savedLatLng = LatLng(0, 0).obs;

  var kategori = ''.obs;
  var lajur = ''.obs;
  var ukuran = ''.obs;
  var kedalaman = ''.obs;
  var potensi = ''.obs;
  var image = XFile('').obs;

  var tglArgs = DateTime.parse(Get.arguments[1]);
  var isLoading = true.obs;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
  );
  late StreamSubscription<Position> positionStream;

  @override
  void onInit() {
    checkLocationService();
    positionStream = locationService.location
        .getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      currentLocationData = position!;
      locationService.locationData.value = position;
      currentLocation.value = LatLng(position.latitude, position.longitude);
      getAddress();
      update();
    });
    mapsController = MapController();
    tanggal.text = DateFormat('yyyy-MM-dd').format(tglArgs);
    ruasJalan.text =
        Get.arguments[0].namaRuasJalan + ' - ' + Get.arguments[0].idRuasJalan;
    getDataMaps(Get.arguments[0].idRuasJalan);
    super.onInit();
  }

  void checkLocationService() async {
    var serviceEnabled =
        await locationService.location.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.location.openLocationSettings();
      if (!serviceEnabled) {
        serviceEnabled = await locationService.location.openLocationSettings();
      }
    }
    currentLocationData = await locationService.location.getCurrentPosition();
    currentLocation.value =
        LatLng(currentLocationData!.latitude, currentLocationData!.longitude);
    await locationService.getAdrres().then((value) {
      address.value = value ?? '';
    });
    onTapCenter();
    isLoading.value = false;
    update();
  }

  void kategoriChanged(var value) {
    kategori.value = value;
  }

  void onLajurChange(var value) {
    lajur.value = value;
  }

  void onUkuranChange(var value) {
    ukuran.value = value;
  }

  void onKedalamanChange(var value) {
    kedalaman.value = value;
  }

  void onPotensiChange(var value) {
    potensi.value = value;
  }

  void onTapCenter() async {
    mapsController.moveAndRotate(currentLocation.value, 18, 0);
  }

  void getAddress() async {
    connectionService.connectionStatus.value
        ? await locationService.getAdrres().then((value) {
            address.value = value ?? '';
          })
        : null;
  }

  void getDataMaps(String id) async {
    if (connectionService.connectionStatus.value) {
      polyline.value = await UtilsProvider.getPolyline(id);
    }
  }

  void openGoogleMaps() {
    locationService.availableMaps.first.showMarker(
        coords: laucher_maps.Coords(
            currentLocation.value.latitude, currentLocation.value.longitude),
        title: 'Lokasi Saat Ini Sudah Sesuai ?',
        description: address.value);
  }

  void onImageChange(value) async {
    image.value = value;
    await locationService.location.getCurrentPosition().then((value) => {
          savedLatLng.value = LatLng(value.latitude, value.longitude),
        });
  }

  void onTapCamera() async {
    if (currentLocationData!.isMocked) {
      Get.snackbar('Error', 'Anda Menggunakan Lokasi Palsu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING);
      return null;
    } else if (currentLocationData!.accuracy > 35) {
      Get.snackbar('Error', 'Lokasi Tidak Akurat Harap Lakukan Calibrasi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING);
      return null;
    } else {
      currentLocationData = await locationService.location.getCurrentPosition();
      currentLocation.value =
          LatLng(currentLocationData!.latitude, currentLocationData!.longitude);
      Get.toNamed('/camera-cam', arguments: [currentLocation.value])!
          .then((value) => {
                onImageChange(value),
              });
    }
  }

  validate() {
    if (sta.text.isEmpty) {
      Get.snackbar('Error', 'STA Harus Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (km1.text.isEmpty) {
      Get.snackbar('Error', 'KM1 Harus Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (km2.text.isEmpty) {
      Get.snackbar('Error', 'KM2 Harus Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (kategori.value == '') {
      Get.snackbar('Error', 'Kategori Harus Dipilih',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (kategori.value == 'Group' && jumlahLubang.text.isEmpty) {
      Get.snackbar('Error', 'Jumlah Lubang Harus Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (panjangLubang.text.isEmpty) {
      Get.snackbar('Error', 'Panjang Lubang Harus Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (lajur.value == '') {
      Get.snackbar('Error', 'Lajur Harus Dipilih',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (ukuran.value == '') {
      Get.snackbar('Error', 'Ukuran Harus Dipilih',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (kedalaman.value == '') {
      Get.snackbar('Error', 'Kedalaman Harus Dipilih',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (potensi.value == '') {
      Get.snackbar('Error', 'Potensi Harus Dipilih',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (keterangan.text.isEmpty) {
      Get.snackbar('Error', 'Keterangan Harus Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (image.value.path == '') {
      Get.snackbar('Error', 'Foto Harus Diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (currentLocationData!.latitude == 0) {
      Get.snackbar('Error', 'Lokasi Tidak Ditemukan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (currentLocationData!.accuracy > 50) {
      Get.snackbar('Error', 'Lokasi Tidak Akurat',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (currentLocationData!.isMocked) {
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

  void onSubmit() async {
    final pathStoreImage =
        '${(await getExternalStorageDirectory())!.path}/survei';
    var storage = await permision_handler.Permission.storage.status;
    if (storage == permision_handler.PermissionStatus.denied ||
        storage == permision_handler.PermissionStatus.limited) {
      await permision_handler.Permission.storage.request();
    } else {
      Directory dir = Directory(pathStoreImage);
      if (dir.existsSync() == false) {
        dir.create(recursive: true);
      }
    }

    var connection = await connectionService.hasNetwork(false);
    if (validate()) {
      if (connection == true) {
        isLoading.value = true;
        await SurveiProvider.storeSurvei({
          "tanggal": tanggal.text,
          "ruas_jalan_id": Get.arguments[0].idRuasJalan,
          "jumlah": jumlahLubang.text,
          "panjang": panjangLubang.text,
          "lat": savedLatLng.value.latitude.toString(),
          "long": savedLatLng.value.longitude.toString(),
          "lokasi_kode": sta.text,
          "lokasi_km": km1.text,
          "lokasi_m": km2.text,
          "kategori": kategori.value,
          "lajur": lajur.value,
          "kategori_kedalaman": '${ukuran.value} - ${kedalaman.value}',
          "potensi_lubang": potensi.value,
          "description": keterangan.text,
        }, image.value)
            .then((value) {
          isLoading.value = false;
          if (value == 'success') {
            _onSuccess('');
          } else {
            _onError();
          }
        });
      } else {
        await _onError();
      }
    }
  }

  _onSuccess(String mode) {
    kategori.value = '';
    jumlahLubang.text = '';
    panjangLubang.text = '';
    sta.text = '';
    km1.text = '';
    km2.text = '';
    image.value = XFile('');
    lajur.value = '';
    kedalaman.value = '';
    potensi.value = '';
    keterangan.text = '';
    ukuran.value = '';
    Get.snackbar('Success', 'Survei Berhasil Dinput $mode',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        borderColor: Colors.green,
        borderWidth: 1);
    isLoading.value = false;
  }

  _onError() async {
    final pathStoreImage =
        '${(await getExternalStorageDirectory())!.path}/survei';
    String fileFormat = image.value.path.split('.').last;
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileFormat';
    File(image.value.path).copy('$pathStoreImage/$fileName');
    await EntryLubangModel(
            ruasJalanId: Get.arguments[0].idRuasJalan,
            tanggal: tanggal.text,
            jumlah: kategori.value == 'Group' ? jumlahLubang.text : '1',
            panjang: double.parse(panjangLubang.text).toString(),
            lat: savedLatLng.value.latitude.toString(),
            long: savedLatLng.value.longitude.toString(),
            lokasiKode: sta.text,
            lokasiKm: km1.text,
            lokasiM: km2.text,
            image: '$pathStoreImage/$fileName',
            lajur: lajur.value,
            kategori: kategori.value,
            kategoriKedalaman: '${ukuran.value} - ${kedalaman.value}',
            potensiLubang: potensi.value == 'true' ? 1 : 0,
            keterangan: keterangan.text)
        .save()
        .then((value) {
      _onSuccess('Ke Draft');
    });
  }

  @override
  void onClose() {
    positionStream.cancel();
    super.onClose();
  }
}
