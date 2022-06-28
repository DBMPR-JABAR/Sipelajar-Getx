import 'package:get/get.dart';

import '../controllers/entry_data_lubang_controller.dart';

class EntryDataLubangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EntryDataLubangController>(
      () => EntryDataLubangController(),
    );
  }
}
