import 'package:get/get.dart';

import '../controllers/entry_pekerjaan_controller.dart';

class EntryPekerjaanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EntryPekerjaanController>(
      () => EntryPekerjaanController(),
    );
  }
}
