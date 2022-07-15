import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sipelajar/app/modules/home/component/showMaps.dart';

import '../../../../../data/model/api/resultSurveiModel.dart';
import '../../../../../data/model/local/entryLubangModel.dart';
import '../../../../../helper/utils.dart';
import '../controllers/result_survei_controller.dart';

class ResultSurveiView extends GetView<ResultSurveiController> {
  const ResultSurveiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Survey ${controller.title}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Text(
                controller.ruas,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            TabBar(
              controller: controller.tabController,
              tabs: controller.listTab,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.yellow,
            ),
            const SizedBox(height: 10),
            Expanded(
                child: TabBarView(
              controller: controller.tabController,
              children: [
                controller.title == 'Offline'
                    ? resultData(data: controller.dataLobang)
                    : resultDataOnline(data: controller.dataLobang),
                controller.title == 'Offline'
                    ? resultData(data: controller.dataPotensi)
                    : resultDataOnline(data: controller.dataPotensi),
              ],
            )),
          ],
        ),
      ),
    );
  }

  resultData({List<EntryLubangModel>? data}) {
    if (data!.isEmpty) {
      return const Center(
        child: Text('Data Masih Kosong', style: TextStyle(fontSize: 20)),
      );
    } else {
      return ListView.separated(
        itemCount: data.length,
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
                        child: Container(
                          width: Get.width * 0.4,
                          height: Get.height * 0.4,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: Image.file(
                                File(data[index].image),
                              ).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            labelBuilder('ID', data[index].id.toString()),
                            const SizedBox(height: 10),
                            labelBuilder('Tanggal', data[index].tanggal),
                            const SizedBox(height: 10),
                            labelBuilder('Ruas', controller.ruas),
                            const SizedBox(height: 10),
                            labelBuilder('Lokasi',
                                ' KM.${data[index].lokasiKode}. ${data[index].lokasiKm} - ${data[index].lokasiM}'),
                            const SizedBox(height: 10),
                            labelBuilder('Kategori', data[index].kategori),
                            const SizedBox(height: 10),
                            labelBuilder(
                                'Ukuran', data[index].kategoriKedalaman),
                            const SizedBox(height: 10),
                            labelBuilder('Panjang', data[index].panjang),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(() => ShowMaps(
                                            dataLobangOffline: data[index],
                                            ruasJalanId:
                                                data[index].ruasJalanId,
                                          ));
                                    },
                                    child: const Text('Detail')),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.deleteLobang(data[index].id!);
                                    },
                                    child: const Text('Hapus')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }

  resultDataOnline({List<SurveiILubangDetail>? data}) {
    if (data!.isEmpty) {
      return const Center(
        child: Text('Data Masih Kosong', style: TextStyle(fontSize: 20)),
      );
    } else {
      return ListView.separated(
        itemCount: data.length,
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
                        child: Container(
                          width: Get.width * 0.4,
                          height: Get.height * 0.4,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  'https://tj.temanjabar.net/map-dashboard/intervention-mage/${data[index].image}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            labelBuilder('ID', data[index].id.toString()),
                            const SizedBox(height: 10),
                            labelBuilder('Tanggal', data[index].tanggal),
                            const SizedBox(height: 10),
                            labelBuilder('Ruas', controller.ruas),
                            const SizedBox(height: 10),
                            labelBuilder('Lokasi',
                                ' KM.${data[index].lokasiKode}. ${data[index].lokasiKm} - ${data[index].lokasiM}'),
                            const SizedBox(height: 10),
                            labelBuilder('Kategori', data[index].kategori),
                            const SizedBox(height: 10),
                            labelBuilder(
                                'Ukuran', data[index].kategoriKedalaman),
                            const SizedBox(height: 10),
                            labelBuilder('Panjang', data[index].panjang),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(() => ShowMaps(
                                            dataLobang: data[index],
                                            ruasJalanId:
                                                data[index].ruasJalanId,
                                          ));
                                    },
                                    child: const Text('Detail')),
                                const SizedBox(width: 10),
                                data[index].status == 'Perencanaan' ||
                                        data[index].status == 'Selesai'
                                    ? Container()
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          controller
                                              .deleteLobang(data[index].id);
                                        },
                                        child: const Text('Hapus')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }
}
