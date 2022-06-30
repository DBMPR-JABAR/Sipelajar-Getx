import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sipelajar/app/helper/loading.dart';

import '../controllers/home_controller.dart';
import '../sapulobang/views/sapulobang_view.dart';

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
                          height: 200,
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
                                SapulobangView(),
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
}
