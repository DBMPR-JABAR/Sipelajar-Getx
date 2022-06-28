import 'package:get/get.dart';

import '../controllers/sapulobang_controller.dart';

class SapulobangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SapulobangController>(
      () => SapulobangController(),
    );
  }
}
