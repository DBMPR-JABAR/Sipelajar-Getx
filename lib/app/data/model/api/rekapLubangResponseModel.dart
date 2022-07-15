import 'dart:convert';

RekapLubangResponseModel rekapLubangResponseModelFromJson(String str) =>
    RekapLubangResponseModel.fromJson(json.decode(str));

String rekapLubangResponseModelToJson(RekapLubangResponseModel data) =>
    json.encode(data.toJson());

class RekapLubangResponseModel {
  RekapLubangResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<DataRekapLubang> data;

  factory RekapLubangResponseModel.fromJson(Map<String, dynamic> json) =>
      RekapLubangResponseModel(
        success: json["success"],
        message: json["message"],
        data: List<DataRekapLubang>.from(
            json["data"].map((x) => DataRekapLubang.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataRekapLubang {
  DataRekapLubang({
    required this.id,
    required this.kategori,
    required this.kategoriKedalaman,
    required this.jumlah,
    required this.panjang,
    required this.tanggal,
    required this.tanggalRencanaPenanganan,
    required this.tanggalPenanganan,
    required this.image,
    required this.imagePenanganan,
    required this.lat,
    required this.long,
    required this.lokasiKode,
    required this.lokasiKm,
    required this.lokasiM,
    required this.monitoringLubangSurveiId,
    required this.status,
    required this.ruasJalanId,
    required this.sup,
    required this.supId,
    required this.uptdId,
    required this.kotaId,
    required this.icon,
    required this.description,
    required this.keterangan,
    required this.lajur,
    required this.potensiLubang,
    required this.createdBy,
    required this.updatedBy,
    required this.userCreate,
    required this.ruas,
  });

  int id;
  String kategori;
  String kategoriKedalaman;
  int jumlah;
  String panjang;
  String? tanggal;
  String? tanggalRencanaPenanganan;
  String? tanggalPenanganan;
  String? image;
  String? imagePenanganan;
  String lat;
  String long;
  String lokasiKode;
  int lokasiKm;
  int lokasiM;
  int monitoringLubangSurveiId;
  String? status;
  String ruasJalanId;
  String? sup;
  int supId;
  int uptdId;
  int? kotaId;
  String? icon;
  String? description;
  String? keterangan;
  String lajur;
  int? potensiLubang;
  int createdBy;
  int? updatedBy;
  UserCreate userCreate;
  Ruas ruas;

  factory DataRekapLubang.fromJson(Map<String, dynamic> json) =>
      DataRekapLubang(
        id: json["id"],
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
        lokasiKm: json["lokasi_km"],
        lokasiM: json["lokasi_m"],
        monitoringLubangSurveiId: json["monitoring_lubang_survei_id"],
        status: json["status"],
        ruasJalanId: json["ruas_jalan_id"],
        sup: json["sup"],
        supId: json["sup_id"],
        uptdId: json["uptd_id"],
        kotaId: json["kota_id"],
        icon: json["icon"],
        description: json["description"],
        keterangan: json["keterangan"],
        lajur: json["lajur"],
        potensiLubang: json["potensi_lubang"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        userCreate: UserCreate.fromJson(json["user_create"]),
        ruas: Ruas.fromJson(json["ruas"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "monitoring_lubang_survei_id": monitoringLubangSurveiId,
        "status": status,
        "ruas_jalan_id": ruasJalanId,
        "sup": sup,
        "sup_id": supId,
        "uptd_id": uptdId,
        "kota_id": kotaId,
        "icon": icon,
        "description": description,
        "keterangan": keterangan,
        "lajur": lajur,
        "potensi_lubang": potensiLubang,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "user_create": userCreate.toJson(),
        "ruas": ruas.toJson(),
      };
}

class Ruas {
  Ruas({
    required this.idRuasJalan,
    required this.namaRuasJalan,
  });

  final String idRuasJalan;
  final String namaRuasJalan;

  factory Ruas.fromJson(Map<String, dynamic> json) => Ruas(
        idRuasJalan: json["id_ruas_jalan"],
        namaRuasJalan: json["nama_ruas_jalan"],
      );

  Map<String, dynamic> toJson() => {
        "id_ruas_jalan": idRuasJalan,
        "nama_ruas_jalan": namaRuasJalan,
      };
}

class UserCreate {
  UserCreate({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory UserCreate.fromJson(Map<String, dynamic> json) => UserCreate(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
