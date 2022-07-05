import 'package:get/get.dart';

import '../controllers/result_survei_controller.dart';

class ResultSurveiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultSurveiController>(
      () => ResultSurveiController(),
    );
  }
}
