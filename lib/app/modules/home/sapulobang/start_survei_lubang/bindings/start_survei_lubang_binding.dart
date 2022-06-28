import 'package:get/get.dart';

import '../controllers/start_survei_lubang_controller.dart';

class StartSurveiLubangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartSurveiLubangController>(
      () => StartSurveiLubangController(),
    );
  }
}
