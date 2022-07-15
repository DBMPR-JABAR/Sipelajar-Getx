import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../services/database/database.dart';

DraftPenanganFromServer draftPenanganFromServerFromJson(String str) =>
    DraftPenanganFromServer.fromJson(json.decode(str));

String draftPenanganFromServerToJson(DraftPenanganFromServer data) =>
    json.encode(data.toJson());

class DraftPenanganFromServer {
  DraftPenanganFromServer({
    required this.success,
    required this.message,
    required this.dataPenanganan,
  });

  bool success;
  String message;
  List<DataPenanganFromServer> dataPenanganan;

  factory DraftPenanganFromServer.fromJson(Map<String, dynamic> json) =>
      DraftPenanganFromServer(
        success: json["success"],
        message: json["message"],
        dataPenanganan: List<DataPenanganFromServer>.from(
            json["data"].map((x) => DataPenanganFromServer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(dataPenanganan.map((x) => x.toJson())),
      };
}

class DataPenanganFromServer {
  DataPenanganFromServer(
      {required this.id,
      required this.namaRuasjJalan,
      required this.kategori,
      required this.kategoriKedalaman,
      required this.jumlah,
      required this.panjang,
      required this.tanggal,
      this.tanggalRencanaPenanganan,
      this.tanggalPenanganan,
      required this.image,
      this.imagePenanganan,
      required this.lat,
      required this.long,
      required this.lokasiKode,
      required this.lokasiKm,
      required this.lokasiM,
      required this.status,
      required this.ruasJalanId,
      required this.keterangan,
      required this.lajur,
      this.updated,
      required this.createdBy});

  int id;
  String namaRuasjJalan;
  String kategori;
  String kategoriKedalaman;
  int jumlah;
  String panjang;
  String tanggal;
  String? tanggalRencanaPenanganan;
  String? tanggalPenanganan;
  String image;
  String? imagePenanganan;
  String lat;
  String long;
  String lokasiKode;
  String lokasiKm;
  String lokasiM;
  String? status;
  String ruasJalanId;
  String keterangan;
  String lajur;
  String? updated;
  String createdBy;

  factory DataPenanganFromServer.fromJson(Map<String, dynamic> json) =>
      DataPenanganFromServer(
        id: json["id"],
        namaRuasjJalan:
            json["ruas"]["nama_ruas_jalan"] ?? json["nama_ruas_jalan"],
        kategori: json["kategori"],
        kategoriKedalaman: json["kategori_kedalaman"],
        jumlah: json["jumlah"],
        panjang: json["panjang"],
        tanggal: json["tanggal"],
        tanggalRencanaPenanganan: json["tanggal_rencana_penanganan"],
        tanggalPenanganan: json["tanggal_penanganan"],
        image: json["image"],
        imagePenanganan: json["image_penanganan"],
        lat: json["lat"],
        long: json["long"],
        lokasiKode: json["lokasi_kode"],
        lokasiKm: json["lokasi_km"].toString(),
        lokasiM: json["lokasi_m"].toString(),
        status: json["status"],
        ruasJalanId: json["ruas_jalan_id"],
        keterangan: json["keterangan"],
        lajur: json["lajur"],
        updated: json["updated"],
        createdBy: json["user_create"]["name"] ?? json["created_by"],
      );

  factory DataPenanganFromServer.fromDb(Map<String, dynamic> json) =>
      DataPenanganFromServer(
        id: json["id"],
        namaRuasjJalan: json["nama_ruas_jalan"],
        kategori: json["kategori"],
        kategoriKedalaman: json["kategori_kedalaman"],
        jumlah: int.parse(json["jumlah"]),
        panjang: json["panjang"],
        tanggal: json["tanggal"],
        tanggalRencanaPenanganan: json["tanggal_rencana_penanganan"],
        tanggalPenanganan: json["tanggal_penanganan"],
        image: json["image"],
        imagePenanganan: json["image_penanganan"],
        lat: json["lat"],
        long: json["long"],
        lokasiKode: json["lokasi_kode"],
        lokasiKm: json["lokasi_km"],
        lokasiM: json["lokasi_m"],
        status: json["status"],
        ruasJalanId: json["ruas_jalan_id"],
        keterangan: json["keterangan"],
        lajur: json["lajur"],
        updated: json["updated"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_ruas_jalan": namaRuasjJalan,
        "kategori": kategori,
        "kategori_kedalaman": kategoriKedalaman,
        "jumlah": jumlah,
        "panjang": panjang,
        "tanggal": tanggal,
        "tanggal_rencana_penanganan": tanggalRencanaPenanganan,
        "tanggal_penanganan": tanggalPenanganan,
        "image": image,
        "image_penanganan": imagePenanganan,
        "lat": lat,
        "long": long,
        "lokasi_kode": lokasiKode,
        "lokasi_km": lokasiKm,
        "lokasi_m": lokasiM,
        "status": status,
        "ruas_jalan_id": ruasJalanId,
        "keterangan": keterangan,
        "lajur": lajur,
        "updated": updated,
        "created_by": createdBy,
      };

  static Future<void> saveMany(List<DataPenanganFromServer> data) async {
    final database = await DatabaseHelper.instance.database;
    List<DataPenanganFromServer> dataDB = await getDataUpdated();
    try {
      if (dataDB.isNotEmpty) {
        for (var i = 0; i < dataDB.length; i++) {
          data.removeWhere((item) => item.id == dataDB[i].id);
        }
      }
      for (var i = 0; i < data.length; i++) {
        await database.insert(
          'draft_data_penanganan_from_server',
          data[i].toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> update(Map<String, Object> data) async {
    final database = await DatabaseHelper.instance.database;
    try {
      await database.update(
        'draft_data_penanganan_from_server',
        data,
        where: 'id = ?',
        whereArgs: [data['id']],
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<List<DataPenanganFromServer>> getDataByRuasJalanIdAndDate(
      String ruasJalanId, String date) async {
    final database = await DatabaseHelper.instance.database;
    final dataQuery = await database.query(
      'draft_data_penanganan_from_server',
      where: 'ruas_jalan_id = ? AND tanggal_rencana_penanganan = ?',
      whereArgs: [ruasJalanId, date],
    );

    List<DataPenanganFromServer> data = dataQuery.isNotEmpty
        ? dataQuery.map((e) => DataPenanganFromServer.fromDb(e)).toList()
        : [];
    return data;
  }

  static Future<List<DataPenanganFromServer>> getDataUpdated() async {
    final database = await DatabaseHelper.instance.database;
    final dataQuery = await database.query(
      'draft_data_penanganan_from_server',
      where: 'updated IS NOT NULL',
    );
    List<DataPenanganFromServer> data = dataQuery.isNotEmpty
        ? dataQuery.map((e) => DataPenanganFromServer.fromDb(e)).toList()
        : [];
    return data;
  }

  static Future<bool> delete(int id) async {
    final database = await DatabaseHelper.instance.database;
    try {
      await database.delete(
        'draft_data_penanganan_from_server',
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
