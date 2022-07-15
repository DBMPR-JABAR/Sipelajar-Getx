import 'package:sqflite/sqflite.dart';

import '../../../services/database/database.dart';

class PenanganModel {
  PenanganModel({
    required this.id,
    required this.keterangan,
    required this.lat,
    required this.long,
    required this.imagePenanganan,
    required this.tanggal,
  });

  final int id;
  final String keterangan;
  final String lat;
  final String long;
  final String imagePenanganan;
  final String tanggal;

  factory PenanganModel.fromJson(Map<String, dynamic> json) => PenanganModel(
        id: json['id'] as int,
        keterangan: json['keterangan'] as String,
        lat: json['lat'] as String,
        long: json['long'] as String,
        imagePenanganan: json['image_penanganan'] as String,
        tanggal: json['tanggal'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'keterangan': keterangan,
        'lat': lat,
        'long': long,
        'image_penanganan': imagePenanganan,
        'tanggal': tanggal,
      };

  @override
  String toString() =>
      'Penangan(id: $id, keterangan: $keterangan, lat: $lat, long: $long, imagePenanganan: $imagePenanganan)';

  Future<void> save() async {
    final database = await DatabaseHelper.instance.database;
    await database.insert(
      'draft_penangan_lubang',
      toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(int id) async {
    final database = await DatabaseHelper.instance.database;
    await database.delete(
      'draft_penangan_lubang',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
