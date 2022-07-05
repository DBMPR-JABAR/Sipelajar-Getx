import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sipelajar/app/data/model/api/resultSurveiModel.dart';
import 'package:sipelajar/app/services/api/utilsProvider.dart';

import '../../../../../data/model/local/entryLubangModel.dart';
import '../../../../../data/model/local/ruasModel.dart';
import '../../../../../services/api/surveiProvider.dart';
import '../../../../../services/location/location.dart';

class StartSurveiLubangController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var dataRuas = <RuasJalanModel>[].obs;
  var dropDownItems = <DropdownMenuItem<RuasJalanModel>>[].obs;
  var isLoading = true.obs;
  var selectedRuas = RuasJalanModel(idRuasJalan: '', namaRuasJalan: '').obs;
  var enableButton = false.obs;
  var fromRoute = Get.arguments;
  var dataSurveiOnline = <SurveiILubangDetail>[].obs;
  var dataSurveiOffline = <EntryLubangModel>[].obs;
  var dataPotensiOnline = <SurveiILubangDetail>[].obs;
  var dataPotensiOffline = <EntryLubangModel>[].obs;
  @override
  void onInit() {
    iniLocationService();
    getDataRuas();
    super.onInit();
  }

  iniLocationService() async {
    await Get.putAsync<LocationService>(() => LocationService().init());

    isLoading.value = false;
  }

  void getDataSurvei() async {
    if (fromRoute == 'Entry Data Lubang') {
      isLoading.value = true;
      dataPotensiOnline.clear();
      dataSurveiOnline.clear();
      dataSurveiOffline.clear();
      dataPotensiOffline.clear();
      var checkConnection = await connection.hasNetwork(false);
      if (checkConnection == true) {
        await SurveiProvider.resultSurvei(selectedRuas.value.idRuasJalan,
                selectedDate.value.toString().substring(0, 10))
            .then((value) {
          dataPotensiOnline.value = value?.data.surveiPotensiLubangDetail ?? [];
          dataSurveiOnline.value = value?.data.surveiLubangDetail ?? [];
        });
      }

      await EntryLubangModel.getAllLubang(selectedRuas.value.idRuasJalan)
          .then((value) {
        dataSurveiOffline.value = value;
      });
      await EntryLubangModel.getallPotensiLubang(selectedRuas.value.idRuasJalan)
          .then((value) {
        dataPotensiOffline.value = value;
      });
      isLoading.value = false;
    }
  }

  getDataRuas() async {
    dataRuas.value = await RuasJalanModel.getAll();
    dropDownItems.value = dataRuas
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text('${e.namaRuasJalan} - ${e.idRuasJalan}'),
            ))
        .toList();
    isLoading.value = false;
  }

  chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      helpText: 'Select DOB',
      cancelText: 'Close',
      confirmText: 'Confirm',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter valid date range',
      fieldHintText: 'Month/Date/Year',
    );
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      getDataSurvei();
    }
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 5))))) {
      return true;
    }
    return false;
  }

  dropDownOnchange(RuasJalanModel value) async {
    selectedRuas.value = value;
    enableButton.value = true;
    getDataSurvei();
  }

  void startSurvei() async {
    if (fromRoute == 'Entry Data Lubang') {
      Get.toNamed('/home/sapulobang/entry-data-lubang', arguments: [
        selectedRuas.value,
        selectedDate.value.toString(),
      ])!
          .then((value) => getDataSurvei());
    } else if (fromRoute == 'Entry Penanganan') {
      Get.toNamed('/home/sapulobang/entry-penanganan',
              arguments: [selectedRuas.value, selectedDate.value.toString()])!
          .then((value) => getDataSurvei());
    } else {
      Get.toNamed('/home/sapulobang/entry-rencana',
          arguments: [selectedRuas.value, selectedDate.value.toString()]);
    }
  }

  void showResult() {
    Get.toNamed('/home/sapulobang/result-survei', arguments: [
      dataSurveiOnline,
      dataPotensiOnline,
      '${selectedRuas.value.namaRuasJalan} - ${selectedRuas.value.idRuasJalan}',
      ''
    ]);
  }

  void showResultOffline() {
    Get.toNamed('/home/sapulobang/result-survei', arguments: [
      dataSurveiOffline,
      dataPotensiOffline,
      '${selectedRuas.value.namaRuasJalan} - ${selectedRuas.value.idRuasJalan}',
      'Offline'
    ]);
  }

  Text renderChildBtn() {
    if (fromRoute == 'Entry Data Lubang') {
      return const Text('Mulai Survey');
    } else if (fromRoute == 'Entry Penanganan') {
      return const Text('Mulai Penanganan');
    } else {
      return const Text('Load Data');
    }
  }
}
