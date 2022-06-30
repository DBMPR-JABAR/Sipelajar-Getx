import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/camera_cam_controller.dart';

class CameraCamView extends GetView<CameraCamController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.isLoading.value
              ? const CircularProgressIndicator()
              : Stack(
                  children: [
                    Column(
                      children: [
                        controller.cameraController.value.isInitialized
                            ? SizedBox(
                                height: Get.height / 1.1,
                                width: Get.width,
                                child: CameraPreview(
                                  controller.cameraController,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Positioned(
                        bottom: 80,
                        left: 5,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lat : ${controller.locationService.locationData.latitude}'
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Text(
                                'Long : ${controller.locationService.locationData.longitude}'
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Text(
                                'Akurasi : ${controller.locationService.locationData.accuracy!.toInt()} m'
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Obx(
                                () => Text(
                                  controller.addres.value,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        )),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: Get.height * 0.09,
                        color: Colors.black,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 40),
                          onPressed: () => controller.takePicture(),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
