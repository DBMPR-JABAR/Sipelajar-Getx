import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
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
                    onPressed: () {}, icon: const Icon(Icons.exit_to_app)),
              ],
            ),
          ),
          body: Column(
            children: [
              Obx(() => CarouselSlider(
                  options: CarouselOptions(
                      height: 180,
                      viewportFraction: 0.9,
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
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          const Center(
                            child: const Text('Sapu Lobang'),
                          ),
                          const Center(
                            child: Text('Kemandoran'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
