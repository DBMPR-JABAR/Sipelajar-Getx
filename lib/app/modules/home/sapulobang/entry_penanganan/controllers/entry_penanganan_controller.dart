import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart' as laucher_maps;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sipelajar/app/helper/loading.dart';
import 'package:sipelajar/app/helper/utils.dart';
import 'package:sipelajar/app/services/api/penangananProvider.dart';
import 'package:permission_handler/permission_handler.dart'
    as permision_handler;
import 'package:sipelajar/app/services/location/location.dart';
import '../../../../../data/model/api/draftPenangananResponseModel.dart';
import '../../../../../services/connectivity/connectivity.dart';

class EntryPenangananController extends GetxController {
  final locationService = Get.find<LocationService>();
  final connectionService = Get.find<ConnectivityService>();
  TextEditingController keterangan = TextEditingController();
  var selectedRuas =
      Get.arguments[0].namaRuasJalan + ' - ' + Get.arguments[0].idRuasJalan;
  String selectedDate = Get.arguments[1];
  var ruasJalanId = Get.arguments[0].idRuasJalan;
  var enableButton = false.obs;
  var data = <DataPenanganFromServer>[].obs;
  var image = XFile('').obs;
  var savedLatLng = LatLng(0, 0).obs;
  var isLoading = true.obs;
  var currentLocationData = Position(
          accuracy: 0,
          latitude: 0,
          longitude: 0,
          timestamp: DateTime.now(),
          altitude: 0,
          speedAccuracy: 0,
          heading: 0,
          speed: 0)
      .obs;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
  );
  late StreamSubscription<Position> positionStream;

  @override
  void onInit() {
    checkLocationService();
    getDataPenanganan();
    positionStream = locationService.location
        .getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      currentLocationData.value = position!;
      locationService.locationData.value = position;
      update();
    });

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
    currentLocationData.value =
        await locationService.location.getCurrentPosition();
  }

  void getDataPenanganan() async {
    isLoading.value = true;
    data.clear();
    Future.delayed(const Duration(seconds: 1), () async {
      if (connectionService.connectionStatus.value) {
        print('get data penanganan');
        await PenangananProvider.getDraftPenanganan().then((value) async {
          if (value == null) {
          } else {
            await DataPenanganFromServer.saveMany(value.dataPenanganan);
          }
        });
      }
      await DataPenanganFromServer.getDataByRuasJalanIdAndDate(
              Get.arguments[0].idRuasJalan,
              selectedDate.toString().substring(0, 10))
          .then((value) {
        data.value = value;
        isLoading.value = false;
      });
    });
  }

  void openGoogleMaps(double lat, double long) {
    locationService.availableMaps.first.showDirections(
      destination: laucher_maps.Coords(lat, long),
    );
  }

  void onImageChange(value) async {
    image.value = value ?? XFile('');
    await locationService.location.getCurrentPosition().then((value) => {
          savedLatLng.value = LatLng(value.latitude, value.longitude),
        });
    enableButton.value = keterangan.text.isNotEmpty &&
        image.value.path != '' &&
        savedLatLng.value != LatLng(0, 0);
  }

  void onTapCamera() async {
    if (currentLocationData.value.isMocked) {
      Get.snackbar('Error', 'Anda Menggunakan Lokasi Palsu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING);
      return null;
    } else if (currentLocationData.value.accuracy > 100) {
      Get.snackbar('Error', 'Lokasi Tidak Akurat Harap Lakukan Calibrasi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING);
      return null;
    } else {
      Get.toNamed('/camera-cam')?.then((value) => {
            onImageChange(value),
          });
    }
  }

  void penanganan(id) {
    Get.dialog(
      Stack(children: [
        WillPopScope(
            child: AlertDialog(
              elevation: 5,
              title: const Text('Konfirmasi Penanganan',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Apakah Anda Yakin ?'),
                    const SizedBox(height: 10),
                    Text(
                      'Data Lobang Ini Sudah Dijadwalkan Pada Tanggal : ${selectedDate.substring(0, 10)} Ambil Foto Untuk Konfirmasi Penanganan',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Keterangan',
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: keterangan,
                      onChanged: (value) {
                        enableButton.value =
                            value.isNotEmpty && image.value.path != '';
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        hintText: 'Keterangan',
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFe3e3e3),
                          width: 1,
                        ),
                        color: const Color(0xFFe3e3e3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => image.value.path == ''
                              ? Container()
                              : SizedBox(
                                  height: 550,
                                  width: Get.width,
                                  child: Image.file(
                                    File(image.value.path),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    primary:
                                        const Color.fromARGB(255, 12, 201, 97),
                                  ),
                                  onPressed: onTapCamera,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('Ambil Gambar',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.photo_camera,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ))),
                          const SizedBox(height: 10),
                          const Text(
                              'Catatan: Pengambilan Foto Harus Dilakukan Secara Searah Jalan Dari Kilometer Rendah Ke Tinggi Dan Posisi Potrait.',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                  width: Get.width * 0.25,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        keterangan.clear();
                        image.value = XFile('');
                      },
                      child: const Text('Batal')),
                ),
                Obx(
                  () => SizedBox(
                    width: Get.width * 0.25,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary:
                              enableButton.value ? Colors.green : Colors.grey,
                        ),
                        onPressed: () async {
                          if (enableButton.value) {
                            onSubmit(id);
                          }
                        },
                        child: const Text('Selesai')),
                  ),
                )
              ],
            ),
            onWillPop: () {
              enableButton.value = false;
              keterangan.clear();
              image.value = XFile('');
              return Future.value(true);
            }),
        Obx(() => isLoading.value ? Loading() : Container()),
      ]),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  void onSubmit(DataPenanganFromServer data) async {
    isLoading.value = true;
    var date = DateTime.now().toString().substring(0, 10);
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
    var valid = await validate(data);
    if (valid) {
      if (connection == true) {
        await PenangananProvider.penangananLubang({
          "lat": savedLatLng.value.latitude.toString(),
          "long": savedLatLng.value.longitude.toString(),
          "keterangan": keterangan.text,
        }, image.value, data.id, date)
            .then((value) {
          isLoading.value = false;
          if (value == 'success') {
            _onSuccess('');
          } else if (value == 'Jarak anda terlalu jauh, Maksimal 3 meter') {
            showToast(value!);
          } else {
            _onError(data.id, date);
          }
        });
      } else {
        await _onError(data.id, date);
      }
    } else {
      isLoading.value = false;
    }
  }

  _onSuccess(String mode) {
    enableButton.value = false;
    Get.back();
    image.value = XFile('');
    keterangan.text = '';
    Get.snackbar('Success', 'Survei Berhasil Dinput $mode',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        borderColor: Colors.green,
        borderWidth: 1);
    getDataPenanganan();
  }

  _onError(int idLobang, String date) async {
    final pathStoreImage =
        '${(await getExternalStorageDirectory())!.path}/survei';
    String fileFormat = image.value.path.split('.').last;
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileFormat';
    File(image.value.path).copy('$pathStoreImage/$fileName');
    await DataPenanganFromServer.update({
      "id": idLobang,
      "tanggal_penanganan": date,
      "keterangan": keterangan.text,
      "image_penanganan": '$pathStoreImage/$fileName',
      "status": 'Selesai',
      "lat": savedLatLng.value.latitude.toString(),
      "long": savedLatLng.value.longitude.toString(),
      "updated": 'Sudah Ditangan Dan Belum Diupload',
    }).then((value) => _onSuccess('ke Draft'));
  }

  Future<bool> validate(DataPenanganFromServer data) async {
    double distance = Geolocator.distanceBetween(
        savedLatLng.value.latitude,
        savedLatLng.value.longitude,
        double.parse(data.lat),
        double.parse(data.long));

    if (distance > 10) {
      Get.snackbar('Jarak anda terlalu jauh, Maksimal 3 meter',
          'Jarak anda saat ini ${distance.toStringAsFixed(1)} meter',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    }
    if (keterangan.text.isEmpty) {
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
    } else if (savedLatLng.value.latitude == 0) {
      Get.snackbar('Error', 'Lokasi Tidak Ditemukan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 1);
      return false;
    } else if (currentLocationData.value.isMocked) {
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

  @override
  void onClose() {
    positionStream.cancel();
    super.onClose();
  }
}
