import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sipelajar/app/modules/home/component/appbar.dart';

import '../component/detail_rekap_lobang.dart';
import '../controllers/rekap_hasil_controller.dart';

class RekapHasilView extends GetView<RekapHasilController> {
  const RekapHasilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar('Rekap Hasil Survey'),
        body: Container(
          padding: const EdgeInsets.all(10),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kerusakan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 250, 79, 67),
                  ),
                  child: InkWell(
                    onTap: () => Get.to(() => const RekapLubang()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Lubang',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white)),
                              const SizedBox(height: 15),
                              Obx(() => Text(
                                  'Total : ${controller.totalLubang.value}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white))),
                              const SizedBox(height: 10),
                              Obx(() => Text(
                                  'Panjang : ${controller.totalPanjangLubang.value} KM',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white))),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Potensi Lubang',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white)),
                              const SizedBox(height: 15),
                              Obx(() => Text(
                                  'Total : ${controller.totalPotensiLubang}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white))),
                              const SizedBox(height: 10),
                              Obx(() => Text(
                                  'Panjang : ${controller.totalPanjangPotensiLubang.value} KM',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 15),
              const Text('Penanganan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                  padding: const EdgeInsets.all(15),
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 238, 0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                          'Total Perencanaan : ${controller.totalPerencanaan.value}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black))),
                      const SizedBox(height: 10),
                      Obx(() => Text(
                          'Total Panjang Perencanaan : ${controller.panjangPerencanaan.value} KM',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black))),
                    ],
                  )),
              const SizedBox(height: 15),
              const Text('Selesai Ditangani',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                  padding: const EdgeInsets.all(15),
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 3, 202, 19),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                          'Total Ditangani : ${controller.totalPenanganan.value}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black))),
                      const SizedBox(height: 10),
                      Obx(() => Text(
                          'Total Panjang Ditangani : ${controller.panjangPenanganan.value} KM',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black))),
                    ],
                  )),
            ],
          ),
        ));
  }
}
