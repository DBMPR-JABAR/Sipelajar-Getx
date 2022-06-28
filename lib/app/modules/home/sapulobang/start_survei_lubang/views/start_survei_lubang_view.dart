import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../data/model/local/ruasModel.dart';
import '../../../../../helper/loading.dart';
import '../../../component/appbar.dart';
import '../controllers/start_survei_lubang_controller.dart';

class StartSurveiLubangView extends GetView<StartSurveiLubangController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar('assets/images/sapulobang.png'),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tanggal', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                datePicker(),
                const SizedBox(height: 10),
                const Text('Pilih Ruas', style: TextStyle(fontSize: 20)),
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
                    child: Obx(() => DropdownButton<RuasJalanModel>(
                        isExpanded: true,
                        hint: const Text('Pilih Ruas'),
                        elevation: 50,
                        value: controller.selectedRuas.value.idRuasJalan == ''
                            ? null
                            : controller.selectedRuas.value,
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (value) {
                          controller.dropDownOnchange(value!);
                        },
                        dropdownColor: Colors.white,
                        items: controller.dropDownItems))),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: controller.enableButton.value
                              ? const Color.fromARGB(255, 245, 193, 7)
                              : Colors.grey,
                          splashFactory: controller.enableButton.value
                              ? null
                              : NoSplash.splashFactory),
                      onPressed: () {
                        controller.enableButton.value
                            ? controller.startSurvei()
                            : null;
                      },
                      child: const Text('Submit'))),
                ),
              ],
            ),
            Obx(() => controller.isLoading.value ? Loading() : Container())
          ]),
        ));
  }

  Container datePicker() {
    return Container(
      width: double.infinity,
      height: Get.height * 0.2,
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
          Obx(
            () => Text(
              DateFormat("dd-MM-yyyy")
                  .format(controller.selectedDate.value)
                  .toString(),
              style: const TextStyle(fontSize: 25),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: const Color.fromARGB(255, 245, 193, 7),
                  ),
                  onPressed: () {
                    controller.chooseDate();
                  },
                  child: const Text('Pilih Tanggal'))),
        ],
      ),
    );
  }
}
