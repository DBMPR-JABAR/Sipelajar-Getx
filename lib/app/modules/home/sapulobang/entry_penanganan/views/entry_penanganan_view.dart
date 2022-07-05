import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/entry_penanganan_controller.dart';

class EntryPenangananView extends GetView<EntryPenangananController> {
  const EntryPenangananView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EntryPenangananView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EntryPenangananView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
