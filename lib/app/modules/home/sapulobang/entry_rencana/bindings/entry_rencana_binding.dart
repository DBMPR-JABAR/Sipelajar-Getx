import 'package:get/get.dart';

import '../controllers/entry_rencana_controller.dart';

class EntryRencanaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EntryRencanaController>(
      () => EntryRencanaController(),
    );
  }
}
