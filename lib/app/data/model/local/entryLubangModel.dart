import 'dart:convert';
import 'package:sqflite/sqflite.dart';

import '../../../services/database/database.dart';

EntryLubangModel entryLubangModelFromJson(String str) =>
    EntryLubangModel.fromJson(json.decode(str));

String entryLubangModelToJson(EntryLubangModel data) =>
    json.encode(data.toJson());

class EntryLubangModel {
  EntryLubangModel(
      {this.id,
      required this.tanggal,
      required this.ruasJalanId,
      this.jumlah,
      required this.panjang,
      required this.lat,
      required this.long,
      required this.lokasiKode,
      required this.lokasiKm,
      required this.lokasiM,
      required this.kategori,
      required this.image,
      required this.lajur,
      required this.kategoriKedalaman,
      required this.keterangan,
      required this.potensiLubang,
      this.uploaded});

  int? id;
  String tanggal;
  String ruasJalanId;
  String? jumlah;
  String panjang;
  String lat;
  String long;
  String lokasiKode;
  String lokasiKm;
  String lokasiM;
  String kategori;
  String image;
  String lajur;
  String kategoriKedalaman;
  String keterangan;
  int potensiLubang;
  int? uploaded;

  factory EntryLubangModel.fromJson(Map<String, dynamic> json) =>
      EntryLubangModel(
        id: json["id"],
        tanggal: json["tanggal"],
        ruasJalanId: json["ruas_jalan_id"],
        jumlah: json["jumlah"],
        panjang: json["panjang"],
        lat: json["lat"],
        long: json["long"],
        lokasiKode: json["lokasi_kode"],
        lokasiKm: json["lokasi_km"],
        lokasiM: json["lokasi_m"],
        kategori: json["kategori"],
        image: json["image"],
        lajur: json["lajur"],
        kategoriKedalaman: json["kategori_kedalaman"],
        keterangan: json["keterangan"],
        potensiLubang: json["potensi_lubang"],
        uploaded: json["uploaded"],
      );

  Map<String, dynamic> toJson() => {
        "tanggal": tanggal,
        "ruas_jalan_id": ruasJalanId,
        "jumlah": jumlah,
        "panjang": panjang,
        "lat": lat,
        "long": long,
        "lokasi_kode": lokasiKode,
        "lokasi_km": lokasiKm,
        "lokasi_m": lokasiM,
        "kategori": kategori,
        "image": image,
        "lajur": lajur,
        "kategori_kedalaman": kategoriKedalaman,
        "potensi_lubang": potensiLubang,
        "keterangan": keterangan,
        "uploaded": 0,
      };

  Future<bool> save() async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert(
        'draft_lubang',
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'draft_lubang',
      where: 'id = ?',
      whereArgs: [id],
    );
    return true;
  }

  static Future<List<EntryLubangModel>> getallPotensiLubang(
      String ruasId) async {
    final db = await DatabaseHelper.instance.database;

    final potensi = await db.rawQuery(
        'SELECT * FROM draft_lubang WHERE ruas_jalan_id = ? AND potensi_lubang = ?',
        [ruasId, 1]);
    List<EntryLubangModel> potensiLobang = potensi.isNotEmpty
        ? potensi.map((c) => EntryLubangModel.fromJson(c)).toList()
        : [];
    return potensiLobang;
  }

  static Future<List<EntryLubangModel>> getAllLubang(String? ruasId) async {
    final db = await DatabaseHelper.instance.database;
    final lobang = await db.rawQuery(
        'SELECT * FROM draft_lubang WHERE ruas_jalan_id = ? AND potensi_lubang = ?',
        [ruasId, 0]);
    List<EntryLubangModel> lubang = lobang.isNotEmpty
        ? lobang.map((c) => EntryLubangModel.fromJson(c)).toList()
        : [];
    return lubang;
  }

  static Future<List<EntryLubangModel>> getAllData() async {
    final db = await DatabaseHelper.instance.database;
    final lobang = await db.rawQuery('SELECT * FROM draft_lubang');
    List<EntryLubangModel> lubang = lobang.isNotEmpty
        ? lobang.map((c) => EntryLubangModel.fromJson(c)).toList()
        : [];
    return lubang;
  }
}
