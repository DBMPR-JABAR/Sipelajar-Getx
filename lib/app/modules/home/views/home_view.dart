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
            title: Image.asset(
              'assets/images/logo-sp2.png',
              fit: BoxFit.contain,
              height: 45,
            ),
          ),
          endDrawer: Drawer(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Stack(children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                        color: Color(0xFF161E29),
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo-sp2.png'),
                          fit: BoxFit.contain,
                        )),
                    child: Container(),
                  ),
                  Column(
                    children: [
                      Obx(() => ListTile(
                            title: Text('Hallo, ${controller.user.value.name}'),
                            onTap: () {
                              Get.toNamed('/profile');
                            },
                          )),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.map),
                          title: const Text('Maps'),
                          onTap: () {
                            Get.offAllNamed('/maps');
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text('About'),
                          onTap: () {
                            Get.offAllNamed('/about');
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.exit_to_app),
                          title: const Text('Logout'),
                          onTap: () {
                            controller.logout();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 50,
                    color: Colors.grey[200],
                    child: Obx(
                      () => Center(
                        child: Text(
                          'Version ${controller.version.value}',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 114, 113, 113),
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )),
            ]),
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
            '/home/start-survei-lubang'),
        if (controller.user.value.role.contains('Kepala') ||
            controller.user.value.role.contains('Admin') ||
            controller.user.value.role.contains('internal'))
          createItemMenu(
              'Entry Rencana Penanganan',
              'assets/icons/img_entry_rencana.png',
              '/home/start-survei-lubang'),
        createItemMenu(
            'Entry Penanganan',
            'assets/icons/img_entry_penanganan.png',
            '/home/start-survei-lubang'),
        createItemMenu('Rekap Hasil Surveri', 'assets/icons/img_rekap.png',
            '/home/rekap-hasil')
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
