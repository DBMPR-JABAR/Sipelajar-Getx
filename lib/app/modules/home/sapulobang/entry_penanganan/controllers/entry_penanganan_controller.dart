import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart' as laucher_maps;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sipelajar/app/services/api/penangananProvider.dart';

import 'package:sipelajar/app/data/model/api/penangananResponseModel.dart';
import 'package:sipelajar/app/services/location/location.dart';

class EntryPenangananController extends GetxController {
  final locationService = Get.find<LocationService>();
  TextEditingController keterangan = TextEditingController();
  var selectedRuas =
      Get.arguments[0].namaRuasJalan + ' - ' + Get.arguments[0].idRuasJalan;
  String selectedDate = Get.arguments[1];
  var ruasJalanId = Get.arguments[0].idRuasJalan;
  var enableButton = false.obs;
  var data = <DataPenangan>[].obs;
  var currentPosition = LatLng(0, 0).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    getDataPenanganan();
    super.onInit();
  }

  void getDataPenanganan() async {
    await locationService.location.getCurrentPosition().then((value) =>
        currentPosition.value = LatLng(value.latitude, value.longitude));
    await PenangananProvider.getPenanganan(ruasJalanId, selectedDate)
        .then((value) {
      data.addAll(value.dataPenangan!);
      data.addAll(value.dataSelesai!);
    });
    isLoading.value = false;
  }

  void openGoogleMaps(double lat, double long) {
    locationService.availableMaps.first.showDirections(
      destination: laucher_maps.Coords(lat, long),
    );
  }

  void rejectLubang(id) {
    Get.dialog(AlertDialog(
      title: const Text('Apakah Anda Yakin ?'),
      content: const Text('Data Lobang Ini Akan Dihapus'),
      actions: [
        SizedBox(
          width: Get.width * 0.25,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Get.back(),
              child: const Text('Batal')),
        ),
        SizedBox(
          width: Get.width * 0.25,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Colors.red,
              ),
              onPressed: () async {},
              child: const Text('Hapus')),
        ),
      ],
    ));
  }

  void jadwalLubang(id) {
    Get.dialog(AlertDialog(
      title: const Text('Konfirmasi Rencana',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Apakah Anda Yakin ?'),
          const SizedBox(height: 10),
          Text(
            'Data Lobang Ini Akan Dijadwalkan Pada Tanggal : ${selectedDate.substring(0, 10)}',
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
              enableButton.value = value.isNotEmpty;
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
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
                  primary: enableButton.value ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  if (enableButton.value) {}
                },
                child: const Text('Jadwalkan')),
          ),
        )
      ],
    ));
  }
}
