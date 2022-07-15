import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sipelajar/app/helper/utils.dart';

import '../../../../../data/model/api/rencanaPenanganModel.dart';
import '../../../../../services/api/perencanaanProvider.dart';

class EntryRencanaController extends GetxController {
  TextEditingController keterangan = TextEditingController();
  var selectedRuas =
      Get.arguments[0].namaRuasJalan + ' - ' + Get.arguments[0].idRuasJalan;
  String selectedDate = Get.arguments[1];
  var ruasJalanId = Get.arguments[0].idRuasJalan;
  var enableButton = false.obs;
  var data = <DataPerencanaan>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    getDatePerencanaan();
    super.onInit();
  }

  void getDatePerencanaan() async {
    isLoading.value = true;
    data.clear();
    Future.delayed(const Duration(seconds: 2), () async {
      await PerencanaanProvider.getPerencanaan(
              Get.arguments[0].idRuasJalan, Get.arguments[1])
          .then((value) {
        data.addAll(value.data);
        data.addAll(value.dataPerencanaan);
      });
      isLoading.value = false;
    });
  }

  void rejectLubang(id) {
    Get.dialog(
        AlertDialog(
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
                  onPressed: () async {
                    await PerencanaanProvider.rejectLobang(id)
                        .then((value) => showToast(value!));
                    Get.back();
                  },
                  child: const Text('Hapus')),
            ),
          ],
        ),
        barrierDismissible: false);
  }

  void jadwalLubang(int id) {
    Get.dialog(
        AlertDialog(
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      if (enableButton.value) {
                        PerencanaanProvider.jadwalLubang(
                                id, selectedDate, keterangan.text)
                            .then((value) {
                          showToast(value!);
                          keterangan.clear();
                          Get.back();
                        });
                        getDatePerencanaan();
                      }
                    },
                    child: const Text('Jadwalkan')),
              ),
            )
          ],
        ),
        barrierDismissible: false);
  }
}
