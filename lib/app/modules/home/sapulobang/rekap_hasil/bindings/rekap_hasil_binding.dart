import 'package:get/get.dart';

import '../controllers/rekap_hasil_controller.dart';

class RekapHasilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekapHasilController>(
      () => RekapHasilController(),
    );
  }
}
