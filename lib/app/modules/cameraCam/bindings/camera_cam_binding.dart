import 'package:get/get.dart';

import '../controllers/camera_cam_controller.dart';

class CameraCamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraCamController>(
      () => CameraCamController(),
    );
  }
}
