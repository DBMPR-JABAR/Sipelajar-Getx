import 'dart:convert';

StartSurveiResponModel startSurveiResponModelFromJson(String str) =>
    StartSurveiResponModel.fromJson(json.decode(str));

String startSurveiResponModelToJson(StartSurveiResponModel data) =>
    json.encode(data.toJson());

class StartSurveiResponModel {
  StartSurveiResponModel({
    required this.success,
    this.data,
  });

  bool success;
  Data? data;

  factory StartSurveiResponModel.fromJson(Map<String, dynamic> json) =>
      StartSurveiResponModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    required this.jumlah,
    required this.panjang,
    required this.tanggal,
    this.lat,
    this.long,
    this.lokasiKode,
    this.ruasJalanId,
    this.supId,
    this.uptdId,
    this.kotaId,
    this.createdAt,
    this.updatedAt,
    required this.ruas,
    required this.surveiLubangDetail,
  });

  int? id;
  int jumlah;
  int panjang;
  DateTime tanggal;
  String? lat;
  String? long;
  String? lokasiKode;
  String? ruasJalanId;
  int? supId;
  int? uptdId;
  int? kotaId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Ruas>? ruas;
  List<dynamic> surveiLubangDetail;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        jumlah: json["jumlah"],
        panjang: json["panjang"],
        tanggal: DateTime.parse(json["tanggal"]),
        lat: json["lat"],
        long: json["long"],
        lokasiKode: json["lokasi_kode"],
        ruasJalanId: json["ruas_jalan_id"],
        supId: json["sup_id"],
        uptdId: json["uptd_id"],
        kotaId: json["kota_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        ruas: List<Ruas>.from(json["ruas"].map((x) => Ruas.fromJson(x))),
        surveiLubangDetail:
            List<dynamic>.from(json["survei_lubang_detail"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jumlah": jumlah,
        "panjang": panjang,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "lat": lat,
        "long": long,
        "lokasi_kode": lokasiKode,
        "ruas_jalan_id": ruasJalanId,
        "sup_id": supId,
        "uptd_id": uptdId,
        "kota_id": kotaId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "ruas": List<dynamic>.from(ruas!.map((x) => x.toJson())),
        "survei_lubang_detail":
            List<dynamic>.from(surveiLubangDetail.map((x) => x)),
      };
}

class Ruas {
  Ruas({
    required this.idRuasJalan,
    required this.namaRuasJalan,
  });

  String idRuasJalan;
  String namaRuasJalan;

  factory Ruas.fromJson(Map<String, dynamic> json) => Ruas(
        idRuasJalan: json["id_ruas_jalan"],
        namaRuasJalan: json["nama_ruas_jalan"],
      );

  Map<String, dynamic> toJson() => {
        "id_ruas_jalan": idRuasJalan,
        "nama_ruas_jalan": namaRuasJalan,
      };
}
