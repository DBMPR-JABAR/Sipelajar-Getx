import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:sipelajar/app/modules/home/sapulobang/entry_rencana/component/previewImage.dart';

import '../../../../../helper/loading.dart';
import '../../../../../helper/utils.dart';
import '../../../component/appbar.dart';
import '../../entry_rencana/component/showMaps.dart';
import '../controllers/entry_penanganan_controller.dart';

class EntryPenangananView extends GetView<EntryPenangananController> {
  const EntryPenangananView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar('Penanganan List'),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 230, 228, 228),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(4, 8), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(controller.selectedRuas,
                          style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: Obx(
                  () => controller.data.isNotEmpty
                      ? ListView.separated(
                          itemCount: controller.data.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            child: Container(
                                              width: Get.width * 0.4,
                                              height: Get.height * 0.4,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      'https://tj.temanjabar.net/map-dashboard/intervention-mage/${controller.data[index].image}'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Get.to(() => PreviewImage(
                                                    imageUrl:
                                                        'https://tj.temanjabar.net/map-dashboard/intervention-mage/${controller.data[index].image}',
                                                  ));
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              labelBuilder(
                                                  'ID',
                                                  controller.data[index].id
                                                      .toString()),
                                              const SizedBox(height: 10),
                                              controller.data[index].status ==
                                                      'Perencanaan'
                                                  ? labelBuilder(
                                                      'Status',
                                                      'Dalam ${controller.data[index].status}'
                                                          .toString())
                                                  : Container(),
                                              const SizedBox(height: 10),
                                              labelBuilder(
                                                  'Mandor',
                                                  controller.data[index]
                                                      .userCreate.name),
                                              const SizedBox(height: 10),
                                              labelBuilder('Lokasi',
                                                  ' KM.${controller.data[index].lokasiKode}. ${controller.data[index].lokasiKm} - ${controller.data[index].lokasiM}'),
                                              const SizedBox(height: 10),
                                              labelBuilder(
                                                  'Kategori',
                                                  controller
                                                      .data[index].kategori),
                                              const SizedBox(height: 10),
                                              labelBuilder(
                                                  'Ukuran',
                                                  controller.data[index]
                                                      .kategoriKedalaman),
                                              const SizedBox(height: 10),
                                              labelBuilder(
                                                  'Panjang',
                                                  controller
                                                      .data[index].panjang),
                                              const SizedBox(height: 10),
                                              labelBuilder(
                                                  'Dijadwalkan Pada',
                                                  controller.data[index]
                                                      .tanggalRencanaPenanganan!),
                                              const SizedBox(height: 10),
                                              // Obx(() => labelBuilder(
                                              //     'Jarak Ke Lokasi',
                                              //     '${(Geolocator.distanceBetween(controller.currentPosition.value.latitude, controller.currentPosition.value.longitude, double.parse(controller.data[index].lat), double.parse(controller.data[index].long)) / 1000).toStringAsFixed(2)} KM')),
                                              // const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: Get.width * 0.25,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              controller.openGoogleMaps(
                                                  double.parse(controller
                                                      .data[index].lat),
                                                  double.parse(controller
                                                      .data[index].long));
                                            },
                                            child: const Text('Directions')),
                                      ),
                                      const SizedBox(width: 10),
                                      controller.data[index].status != 'Selesai'
                                          ? SizedBox(
                                              width: Get.width * 0.25,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    primary: Colors.green,
                                                  ),
                                                  onPressed: () {
                                                    controller.jadwalLubang(
                                                        controller
                                                            .data[index].id);
                                                  },
                                                  child: const Text('Tangani')),
                                            )
                                          : SizedBox(
                                              width: Get.width * 0.4,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  onPressed: null,
                                                  child: const Text(
                                                      'Sudah Ditangani')),
                                            )
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('Tidak ada data'),
                        ),
                ))
              ],
            ),
          ),
          Obx(() => controller.isLoading.value ? Loading() : Container())
        ]));
  }
}
