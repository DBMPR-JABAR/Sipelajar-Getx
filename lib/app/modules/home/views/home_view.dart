import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sipelajar/app/helper/loading.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo-sp2.png',
                  fit: BoxFit.contain,
                  height: 45,
                ),
                IconButton(
                    onPressed: () => controller.logout(),
                    icon: const Icon(Icons.exit_to_app)),
              ],
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Obx(() => CarouselSlider(
                      options: CarouselOptions(
                          height: 180,
                          viewportFraction: 0.7,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 10),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          pauseAutoPlayOnTouch: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {}),
                      items: controller.carouselList)),
                  Expanded(
                    child: Column(
                      children: [
                        TabBar(
                          controller: controller.tabController,
                          tabs: controller.listTab,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TabBarView(
                              controller: controller.tabController,
                              children: [
                                Obx(() => sapulobangView()),
                                const Center(
                                  child: Text('Upcoming'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Obx(() => controller.isLoading.value ? Loading() : Container()),
            ],
          )),
    );
  }

  GridView sapulobangView() {
    return GridView.extent(
      maxCrossAxisExtent: Get.width / 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        createItemMenu('Entry Data Lubang', 'assets/icons/img_entry_lubang.png',
            '/home/sapulobang/start-survei-lubang'),
        if (controller.user.value.role.contains('Kepala') ||
            controller.user.value.role.contains('Admin') ||
            controller.user.value.role.contains('internal'))
          createItemMenu(
              'Entry Rencana Penanganan',
              'assets/icons/img_entry_rencana.png',
              '/home/sapulobang/start-survei-lubang'),
        createItemMenu(
            'Entry Penanganan',
            'assets/icons/img_entry_penanganan.png',
            '/home/sapulobang/start-survei-lubang'),
        createItemMenu('Rekap Hasil Surveri', 'assets/icons/img_rekap.png',
            '/home/sapulobang/rekap-hasil')
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
