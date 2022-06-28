import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sapulobang_controller.dart';

class SapulobangView extends GetView<SapulobangController> {
  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: Get.width / 2.5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        createItemMenu('Entry Data Lubang', 'assets/icons/img_entry_lubang.png',
            '/home/sapulobang/start-survei-lubang'),
        createItemMenu('Entry Penanganan',
            'assets/icons/img_entry_penanganan.png', 'entry_penanganan'),
        createItemMenu('Rekap Hasil Surveri', 'assets/icons/img_rekap.png',
            'rekap_surveri'),
      ],
    );
  }
}

InkWell createItemMenu(String title, String image, String route) {
  return InkWell(
    onTap: () {
      Get.toNamed(route);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFe3e3e3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            fit: BoxFit.contain,
            height: 80,
          ),
          Center(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    ),
  );
}
