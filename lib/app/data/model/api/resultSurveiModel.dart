import 'dart:convert';

ResultSurveiResponseModel resultSurveiResponseModelFromJson(String str) =>
    ResultSurveiResponseModel.fromJson(json.decode(str));

String resultSurveiResponseModelToJson(ResultSurveiResponseModel data) =>
    json.encode(data.toJson());

class ResultSurveiResponseModel {
  ResultSurveiResponseModel({
    required this.success,
    required this.data,
  });

  bool success;
  DataSurvei data;

  factory ResultSurveiResponseModel.fromJson(Map<String, dynamic> json) =>
      ResultSurveiResponseModel(
        success: json["success"],
        data: DataSurvei.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class DataSurvei {
  DataSurvei({
    this.id,
    this.jumlah,
    this.panjang,
    required this.tanggal,
    this.lat,
    this.long,
    this.lokasiKode,
    this.ruasJalanId,
    this.supId,
    this.uptdId,
    this.kotaId,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.ruas,
    this.surveiLubangDetail,
    this.surveiPotensiLubangDetail,
  });

  int? id;
  int? jumlah;
  String? panjang;
  String tanggal;
  String? lat;
  String? long;
  String? lokasiKode;
  String? ruasJalanId;
  int? supId;
  int? uptdId;
  int? kotaId;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  Ruas ruas;
  List<SurveiILubangDetail>? surveiLubangDetail;
  List<SurveiILubangDetail>? surveiPotensiLubangDetail;

  factory DataSurvei.fromJson(Map<String, dynamic> json) => DataSurvei(
        id: json["id"],
        jumlah: json["jumlah"],
        panjang: json["panjang"],
        tanggal: json["tanggal"],
        lat: json["lat"],
        long: json["long"],
        lokasiKode: json["lokasi_kode"],
        ruasJalanId: json["ruas_jalan_id"],
        supId: json["sup_id"],
        uptdId: json["uptd_id"],
        kotaId: json["kota_id"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        ruas: Ruas.fromJson(json["ruas"]),
        surveiLubangDetail: json['survei_lubang_detail'] == null
            ? null
            : List<SurveiILubangDetail>.from(json["survei_lubang_detail"]
                .map((x) => SurveiILubangDetail.fromJson(x))),
        surveiPotensiLubangDetail: json['survei_potensi_lubang_detail'] == null
            ? null
            : List<SurveiILubangDetail>.from(
                json["survei_potensi_lubang_detail"]
                    .map((x) => SurveiILubangDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jumlah": jumlah,
        "panjang": panjang,
        "tanggal": tanggal,
        "lat": lat,
        "long": long,
        "lokasi_kode": lokasiKode,
        "ruas_jalan_id": ruasJalanId,
        "sup_id": supId,
        "uptd_id": uptdId,
        "kota_id": kotaId,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "ruas": ruas.toJson(),
        "survei_lubang_detail":
            List<dynamic>.from(surveiLubangDetail!.map((x) => x.toJson())),
        "survei_potensi_lubang_detail": List<dynamic>.from(
            surveiPotensiLubangDetail!.map((x) => x.toJson())),
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

class SurveiILubangDetail {
  SurveiILubangDetail({
    required this.id,
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
    this.monitoringLubangSurveiId,
    this.status,
    required this.ruasJalanId,
    required this.sup,
    required this.supId,
    required this.uptdId,
    required this.kotaId,
    required this.icon,
    this.description,
    required this.keterangan,
    required this.lajur,
    required this.potensiLubang,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.monitoringPotensiLubangSurveiId,
  });

  int id;
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
  int? monitoringLubangSurveiId;
  String? status;
  String ruasJalanId;
  String sup;
  int supId;
  int uptdId;
  int kotaId;
  String icon;
  String? description;
  String keterangan;
  String lajur;
  bool potensiLubang;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  int? monitoringPotensiLubangSurveiId;

  factory SurveiILubangDetail.fromJson(Map<String, dynamic> json) =>
      SurveiILubangDetail(
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
        lokasiKm: json["lokasi_km"].toString(),
        lokasiM: json["lokasi_m"].toString(),
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
        potensiLubang: json["potensi_lubang"] == 0 ? false : true,
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        monitoringPotensiLubangSurveiId:
            json["monitoring_potensi_lubang_survei_id"],
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
        "created_at": createdAt,
        "updated_at": updatedAt,
        "monitoring_potensi_lubang_survei_id": monitoringPotensiLubangSurveiId,
      };
}
