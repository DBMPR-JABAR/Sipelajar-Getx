import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sipelajar/app/data/model/local/userModel.dart';
import 'package:sipelajar/app/helper/utils.dart';
import 'package:sipelajar/app/services/api/authProvider.dart';
import 'package:sipelajar/app/services/connectivity/connectivity.dart';

import '../../../data/model/local/ruasModel.dart';

class LoginController extends GetxController {
  final connection = Get.find<ConnectivityService>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final storage = GetStorage();
  var buttonEnabled = false.obs;
  var isLoading = false.obs;
  var isShowPassword = false.obs;
  var buttonEnable = false.obs;
  var usernameError = ''.obs;
  var passwordError = ''.obs;

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo = info;
    update();
  }

  @override
  void onInit() {
    _initPackageInfo();
    super.onInit();
  }

  void usernameOnChanged(String value) {
    usernameError.value = '';
    validate();
  }

  void passwordOnChanged(String value) {
    passwordError.value = '';
    validate();
  }

  void validate() {
    if (usernameController.text.isEmpty) {
      buttonEnabled.value = false;
      usernameError.value = 'Username tidak boleh kosong';
    } else if (passwordController.text.isEmpty) {
      buttonEnabled.value = false;
      passwordError.value = 'Password tidak boleh kosong';
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password minimal 6 karakter';
      buttonEnabled.value = false;
    } else {
      buttonEnabled.value = true;
    }
  }

  void login() async {
    isLoading.value = true;
    var checkConnection = await connection.hasNetwork(false);
    if (checkConnection == true) {
      await AuthProvider.login(
        usernameController.text,
        passwordController.text,
      ).then((value) async {
        if (value.status == 'success') {
          await storage.write('accestoken', value.data.token!.accessToken);
          await UserModel(
                  name: value.data.user!.name,
                  email: usernameController.text,
                  password: passwordController.text,
                  token: value.data.token!.accessToken,
                  encryptedId: value.data.user!.encryptedId)
              .save();
          List<RuasJalanModel> ruas = [];
          for (var item in value.data.user!.ruas) {
            ruas.add(RuasJalanModel(
                idRuasJalan: item.idRuasJalan,
                namaRuasJalan: item.namaRuasJalan));
          }
          await RuasJalanModel.saveMany(ruas);
          isLoading.value = false;
          return Get.offAllNamed('/home');
        } else {
          usernameError.value = 'Username Salah';
          passwordError.value = 'Password Salah';
          showToast('Username atau Password Salah');
        }
      });
    } else {
      showToast('Tidak ada koneksi internet');
      isLoading.value = false;
    }
  }
}
