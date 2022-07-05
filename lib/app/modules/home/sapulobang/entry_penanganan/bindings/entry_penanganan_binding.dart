import 'package:get/get.dart';

import '../controllers/entry_penanganan_controller.dart';

class EntryPenangananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EntryPenangananController>(
      () => EntryPenangananController(),
    );
  }
}
