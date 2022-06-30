import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
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
    final String path =
        '${(await getExternalStorageDirectory())!.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final photo = await cameraController.takePicture();
    Get.to(() => PreviewImage(
              path: photo,
            ))!
        .then((value) => value ? Get.back(result: photo) : null);
  }

  void getAddres() async {
    await locationService.location.getLocation().then((value) {
      latLng.value = LatLng(value.latitude!, value.longitude!);
    });
    await locationService
        .getAdrres(latLng.value.latitude, latLng.value.longitude)
        .then((value) {
      addres.value = value;
    });
  }

  @override
  void onInit() {
    getAddres();
    cameraInit();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
