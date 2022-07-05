import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sipelajar/app/modules/cameraCam/views/preview.dart';

import '../../../services/location/location.dart';

class CameraCamController extends GetxController {
  XFile? image;
  late CameraController cameraController;
  var isLoading = true.obs;
  final locationService = Get.find<LocationService>();
  var addres = ''.obs;
  var latLng = LatLng(0, 0).obs;

  Future<void> cameraInit() async {
    var cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    await cameraController
        .initialize()
        .then((value) => isLoading.value = false);
  }

  void takePicture() async {
    if (!cameraController.value.isInitialized) {
      return null;
    }
    cameraController.setFlashMode(FlashMode.off);
    final photo = await cameraController.takePicture();
    Get.to(() => PreviewImage(
              path: photo,
            ))!
        .then((value) => value ? Get.back(result: photo) : null);
  }

  getAddres() async {
    await locationService.getAdrres().then((value) {
      addres.value = value ?? '';
    });
  }

  @override
  void onInit() {
    cameraInit();
    super.onInit();
    getAddres();
  }
}
