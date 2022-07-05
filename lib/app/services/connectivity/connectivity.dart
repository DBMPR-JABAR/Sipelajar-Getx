import 'dart:async';

import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sipelajar/app/data/model/local/entryLubangModel.dart';
import 'package:sipelajar/app/helper/utils.dart';
import 'package:sipelajar/app/services/api/surveiProvider.dart';
import 'package:sipelajar/app/services/api/utilsProvider.dart';

class ConnectivityService extends GetxService {
  var connectionStatus = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription streamSubscription;

  Future<ConnectivityService> init() async {
    streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateState);

    return this;
  }

  _updateState(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        await hasNetwork(true).then((value) async {
          if (value == true) {
            uploadData();
          } else {
            await hasNetwork(false).then((value) {
              if (value == true) {
                uploadData();
              }
            });
          }
        });
        break;
      case ConnectivityResult.mobile:
        await hasNetwork(true).then((value) async {
          if (value == true) {
            uploadData();
          } else {
            await hasNetwork(false).then((value) {
              if (value == true) {
                uploadData();
              }
            });
          }
        });
        break;
      case ConnectivityResult.none:
        connectionStatus.value = false;
        Get.snackbar(
          '',
          '',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color.fromARGB(255, 255, 112, 102),
          duration: const Duration(seconds: 3),
          barBlur: 50,
          titleText: const Center(
            child: Text(
              'Koneksi Internet Tidak Terhubung',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        );
        break;
    }
  }

  Future<bool?> hasNetwork(bool delay) async {
    delay ? await Future.delayed(const Duration(seconds: 5)) : null;
    var connected = await UtilsProvider.ping().then((value) {
      if (value == '200') {
        return true;
      } else {
        return false;
      }
    });
    connectionStatus.value = connected;
    return connected;
  }

  uploadData() async {
    List<EntryLubangModel> data = await EntryLubangModel.getAllData();
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        await SurveiProvider.storeSurvei({
          "tanggal": data[i].tanggal,
          "ruas_jalan_id": data[i].ruasJalanId,
          "jumlah": data[i].jumlah ?? '',
          "panjang": data[i].panjang,
          "lat": data[i].lat,
          "long": data[i].long,
          "lokasi_kode": data[i].lokasiKode,
          "lokasi_km": data[i].lokasiKm,
          "lokasi_m": data[i].lokasiM,
          "kategori": data[i].kategori,
          "lajur": data[i].lajur,
          "kategori_kedalaman": data[i].kategoriKedalaman,
          "potensi_lubang": data[i].potensiLubang == 1 ? 'true' : 'false',
          "description": data[i].keterangan,
        }, XFile(data[i].image))
            .then((value) {
          if (value == 'success') {
            EntryLubangModel.delete(data[i].id!).then((value) {
              if (value) {
                showToast('Draft Dengan ID ${data[i].id} Berhasil Di Upload');
              }
            });
          }
        });
      }
    }
  }
}
