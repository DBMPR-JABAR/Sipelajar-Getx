import 'dart:convert';

PenanganResponseModel penanganResponseModelFromJson(String str) =>
    PenanganResponseModel.fromJson(json.decode(str));

String penanganResponseModelToJson(PenanganResponseModel data) =>
    json.encode(data.toJson());

class PenanganResponseModel {
  PenanganResponseModel({
    required this.success,
    required this.message,
    this.dataPenangan,
    this.dataSelesai,
  });

  bool success;
  String message;
  List<DataPenangan>? dataPenangan;
  List<DataPenangan>? dataSelesai;

  factory PenanganResponseModel.fromJson(Map<String, dynamic> json) =>
      PenanganResponseModel(
        success: json["success"],
        message: json["message"],
        dataPenangan: List<DataPenangan>.from(
            json["data"].map((x) => DataPenangan.fromJson(x))),
        dataSelesai: List<DataPenangan>.from(
            json["data_selesai"].map((x) => DataPenangan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(dataPenangan!.map((x) => x.toJson())),
        "data_selesai": List<dynamic>.from(dataSelesai!.map((x) => x.toJson())),
      };
}

class DataPenangan {
  DataPenangan({
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
    required this.createdAt,
    required this.updatedAt,
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
  dynamic tanggalPenanganan;
  String image;
  dynamic imagePenanganan;
  String lat;
  String long;
  String lokasiKode;
  int lokasiKm;
  int lokasiM;
  int monitoringLubangSurveiId;
  String status;
  String ruasJalanId;
  String sup;
  int supId;
  int uptdId;
  int kotaId;
  String icon;
  String description;
  String keterangan;
  String lajur;
  int potensiLubang;
  int createdBy;
  int updatedBy;
  String createdAt;
  String updatedAt;
  UserCreate userCreate;
  Ruas ruas;

  factory DataPenangan.fromJson(Map<String, dynamic> json) => DataPenangan(
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_create": userCreate.toJson(),
        "ruas": ruas.toJson(),
      };
}

class Ruas {
  Ruas({
    required this.id,
    required this.idRuasJalan,
    required this.namaRuasJalan,
    required this.sup,
    required this.lokasi,
    required this.panjang,
    required this.staAwal,
    required this.staAkhir,
    required this.latAwal,
    required this.longAwal,
    required this.latAkhir,
    required this.longAkhir,
    required this.l,
    required this.kabKota,
    required this.kotaId,
    required this.kdSppjj,
    required this.nmSppjj,
    required this.latCtr,
    required this.longCtr,
    required this.wilUptd,
    required this.uptdId,
    required this.createdDate,
    required this.createdBy,
    required this.updatedDate,
    required this.updatedBy,
    required this.foto,
    required this.foto1,
    required this.foto2,
    required this.video,
    required this.index,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String idRuasJalan;
  String namaRuasJalan;
  dynamic sup;
  dynamic lokasi;
  int panjang;
  String staAwal;
  String staAkhir;
  double latAwal;
  double longAwal;
  double latAkhir;
  double longAkhir;
  dynamic l;
  String kabKota;
  int kotaId;
  String kdSppjj;
  String nmSppjj;
  double latCtr;
  double longCtr;
  String wilUptd;
  int uptdId;
  dynamic createdDate;
  dynamic createdBy;
  String updatedDate;
  dynamic updatedBy;
  dynamic foto;
  dynamic foto1;
  dynamic foto2;
  dynamic video;
  String index;
  dynamic createdAt;
  String updatedAt;

  factory Ruas.fromJson(Map<String, dynamic> json) => Ruas(
        id: json["id"],
        idRuasJalan: json["id_ruas_jalan"],
        namaRuasJalan: json["nama_ruas_jalan"],
        sup: json["sup"],
        lokasi: json["lokasi"],
        panjang: json["panjang"],
        staAwal: json["sta_awal"],
        staAkhir: json["sta_akhir"],
        latAwal: json["lat_awal"].toDouble(),
        longAwal: json["long_awal"].toDouble(),
        latAkhir: json["lat_akhir"].toDouble(),
        longAkhir: json["long_akhir"].toDouble(),
        l: json["L"],
        kabKota: json["kab_kota"],
        kotaId: json["kota_id"],
        kdSppjj: json["kd_sppjj"],
        nmSppjj: json["nm_sppjj"],
        latCtr: json["lat_ctr"].toDouble(),
        longCtr: json["long_ctr"].toDouble(),
        wilUptd: json["wil_uptd"],
        uptdId: json["uptd_id"],
        createdDate: json["created_date"],
        createdBy: json["created_by"],
        updatedDate: json["updated_date"],
        updatedBy: json["updated_by"],
        foto: json["foto"],
        foto1: json["foto_1"],
        foto2: json["foto_2"],
        video: json["video"],
        index: json["index"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_ruas_jalan": idRuasJalan,
        "nama_ruas_jalan": namaRuasJalan,
        "sup": sup,
        "lokasi": lokasi,
        "panjang": panjang,
        "sta_awal": staAwal,
        "sta_akhir": staAkhir,
        "lat_awal": latAwal,
        "long_awal": longAwal,
        "lat_akhir": latAkhir,
        "long_akhir": longAkhir,
        "L": l,
        "kab_kota": kabKota,
        "kota_id": kotaId,
        "kd_sppjj": kdSppjj,
        "nm_sppjj": nmSppjj,
        "lat_ctr": latCtr,
        "long_ctr": longCtr,
        "wil_uptd": wilUptd,
        "uptd_id": uptdId,
        "created_date": createdDate,
        "created_by": createdBy,
        "updated_date": updatedDate,
        "updated_by": updatedBy,
        "foto": foto,
        "foto_1": foto1,
        "foto_2": foto2,
        "video": video,
        "index": index,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class UserCreate {
  UserCreate({
    required this.name,
  });

  String name;

  factory UserCreate.fromJson(Map<String, dynamic> json) => UserCreate(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
