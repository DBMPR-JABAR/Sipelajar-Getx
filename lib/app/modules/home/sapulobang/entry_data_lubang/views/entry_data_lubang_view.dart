import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../../helper/loading.dart';
import '../../../component/appbar.dart';
import '../controllers/entry_data_lubang_controller.dart';

class EntryDataLubangView extends GetView<EntryDataLubangController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar('Entry Data Lubang'),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelBuilder('Tanggal'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.tanggal,
                  decoration: InputDecoration(
                    enabled: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                labelBuilder('Ruas Jalan'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.ruasJalan,
                  decoration: InputDecoration(
                    enabled: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                labelBuilder('Lokasi STA'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Get.width * 0.2,
                      child: TextField(
                        controller: controller.sta,
                        inputFormatters: [UpperCaseTextFormatter()],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text('KM.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: Get.width * 0.3,
                      child: TextField(
                        controller: controller.km1,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.3,
                      child: TextField(
                        controller: controller.km2,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                labelBuilder('Panjang Lubang'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.panjangLubang,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    suffix: const Text('Meter',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 15),
                labelBuilder('Lajur'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                              value: 'Kiri',
                              groupValue: controller.lajur.value,
                              onChanged: (value) {
                                controller.onLajurChange(value);
                              }),
                        ),
                        const Text('Kiri',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(() => Radio(
                            value: 'As',
                            groupValue: controller.lajur.value,
                            onChanged: (value) {
                              controller.onLajurChange(value);
                            })),
                        const Text('As',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(() => Radio(
                            value: 'Kanan',
                            groupValue: controller.lajur.value,
                            onChanged: (value) {
                              controller.onLajurChange(value);
                            })),
                        const Text('Kanan',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 15),
                labelBuilder('Ukuran Lubang'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                              value: 'Kecil',
                              groupValue: controller.ukuran.value,
                              onChanged: (value) {
                                controller.onUkuranChange(value);
                              }),
                        ),
                        const Text('Kecil',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(() => Radio(
                            value: 'Besar',
                            groupValue: controller.ukuran.value,
                            onChanged: (value) {
                              controller.onUkuranChange(value);
                            })),
                        const Text('Besar',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                const Text(
                    'Catatan Lubang Kecil ( Diameter < 50cm ), Lubang Besar ( Diameter > 50cm )',
                    style: TextStyle(
                      fontSize: 14,
                    )),
                const SizedBox(height: 15),
                labelBuilder('Kedalaman Lubang'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                              value: 'Dangkal',
                              groupValue: controller.kedalaman.value,
                              onChanged: (value) {
                                controller.onKedalamanChange(value);
                              }),
                        ),
                        const Text('Dangkal',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(() => Radio(
                            value: 'Dalam',
                            groupValue: controller.kedalaman.value,
                            onChanged: (value) {
                              controller.onKedalamanChange(value);
                            })),
                        const Text('Dalam',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                const Text(
                    'Catatan Lubang Dangkal ( Kedalaman < 5cm ), Lubang Dalam ( Kedalaman > 5cm )',
                    style: TextStyle(
                      fontSize: 14,
                    )),
                const SizedBox(height: 15),
                labelBuilder('Potensi Menjadi Lubang'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                              value: 'true',
                              groupValue: controller.potensi.value,
                              onChanged: (value) {
                                controller.onPotensiChange(value);
                              }),
                        ),
                        const Text('Berpotensi Lubang',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(() => Radio(
                            value: 'false',
                            groupValue: controller.potensi.value,
                            onChanged: (value) {
                              controller.onPotensiChange(value);
                            })),
                        const Text('Sudah Menjadi Lubang',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                const Text(
                    'Catatan Berpotensi Lubang Merupakan Lubang Yang Akan Menjadi Lubang Dikemudian Hari',
                    style: TextStyle(
                      fontSize: 14,
                    )),
                const SizedBox(height: 15),
                labelBuilder('Keterangan'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.keterangan,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'Masukan Keterangan',
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                labelBuilder('Upload Gambar'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFe3e3e3),
                      width: 1,
                    ),
                    color: const Color(0xFFe3e3e3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                primary: Color.fromARGB(255, 12, 201, 97),
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Ambil Gambar',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.photo_camera,
                                    color: Colors.black,
                                  ),
                                ],
                              ))),
                      const SizedBox(height: 10),
                      const Text(
                          'Catatan: Pengambilan Foto Harus Berada Dilakukan Secara Horizontal / Searah Jalan Dari Kilometer Rendah Ke Tinggi',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Text labelBuilder(String label) => Text(label,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}