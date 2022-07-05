import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/rekap_hasil_controller.dart';

class RekapHasilView extends GetView<RekapHasilController> {
  const RekapHasilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RekapHasilView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'RekapHasilView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
