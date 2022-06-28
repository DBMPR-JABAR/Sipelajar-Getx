import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/model/local/ruasModel.dart';
import '../../../../../helper/utils.dart';
import '../../../../../services/api/surveiProvider.dart';

class StartSurveiLubangController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var dataRuas = <RuasJalanModel>[].obs;
  var dropDownItems = <DropdownMenuItem<RuasJalanModel>>[].obs;
  var isLoading = true.obs;
  var selectedRuas = RuasJalanModel(idRuasJalan: '', namaRuasJalan: '').obs;
  var enableButton = false.obs;

  @override
  void onInit() {
    getDataRuas();
    super.onInit();
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
        lastDate: DateTime(2024),
        helpText: 'Select DOB',
        cancelText: 'Close',
        confirmText: 'Confirm',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter valid date range',
        fieldHintText: 'Month/Date/Year',
        selectableDayPredicate: disableDate);
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 5))))) {
      return true;
    }
    return false;
  }

  dropDownOnchange(RuasJalanModel value) {
    selectedRuas.value = value;
    enableButton.value = true;
  }

  void startSurvei() async {
    Get.toNamed('/home/sapulobang/entry-data-lubang',
        arguments: [selectedRuas.value, selectedDate.value.toString()]);
  }
}
