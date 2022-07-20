import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/entry_pekerjaan_controller.dart';

class EntryPekerjaanView extends GetView<EntryPekerjaanController> {
  const EntryPekerjaanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EntryPekerjaanView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EntryPekerjaanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
