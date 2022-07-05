import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sapulobang_controller.dart';

class SapulobangView extends GetView<SapulobangController> {
  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: Get.width / 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        createItemMenu('Entry Data Lubang', 'assets/icons/img_entry_lubang.png',
            '/home/sapulobang/start-survei-lubang'),
        createItemMenu(
            'Entry Rencana Penanganan',
            'assets/icons/img_entry_rencana.png',
            '/home/sapulobang/start-survei-lubang'),
        createItemMenu(
            'Entry Penanganan',
            'assets/icons/img_entry_penanganan.png',
            '/home/sapulobang/start-survei-lubang'),
        createItemMenu('Rekap Hasil Surveri', 'assets/icons/img_rekap.png',
            'rekap_surveri')
      ],
    );
  }
}

InkWell createItemMenu(String title, String image, String route) {
  return InkWell(
    onTap: () {
      Get.toNamed(route, arguments: title);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFe3e3e3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            fit: BoxFit.contain,
            height: 100,
          ),
          Text(title,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        ],
      ),
    ),
  );
}
