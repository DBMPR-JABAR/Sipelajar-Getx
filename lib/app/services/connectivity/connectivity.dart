import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  static const signalChanell = MethodChannel('getSignalStrength');
  var connectionStatus = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription streamSubscription;
  bool initService = true;

  Future<ConnectivityService> init() async {
    streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateState);

    return this;
  }

  _updateState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        if (initService == false) {
          Get.snackbar(
            '',
            '',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 117, 209, 120),
            duration: const Duration(seconds: 3),
            barBlur: 50,
            titleText: const Center(
              child: Text(
                'Koneksi Internet Kembali Terhubung',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }
        connectionStatus.value = true;
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = true;
        if (initService == false) {
          Get.snackbar(
            '',
            '',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromARGB(255, 117, 209, 120),
            duration: const Duration(seconds: 3),
            barBlur: 50,
            titleText: const Center(
              child: Text(
                'Koneksi Internet Kembali Terhubung',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }
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
    initService = false;
  }
}
