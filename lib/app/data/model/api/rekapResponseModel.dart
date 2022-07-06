import 'dart:convert';

RekapResponseModel rekapResponseModelFromJson(String str) =>
    RekapResponseModel.fromJson(json.decode(str));

String rekapResponseModelToJson(RekapResponseModel data) =>
    json.encode(data.toJson());

class RekapResponseModel {
  RekapResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory RekapResponseModel.fromJson(Map<String, dynamic> json) =>
      RekapResponseModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.jumlah,
    required this.panjang,
  });

  Jumlah jumlah;
  Jumlah panjang;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        jumlah: Jumlah.fromJson(json["jumlah"]),
        panjang: Jumlah.fromJson(json["panjang"]),
      );

  Map<String, dynamic> toJson() => {
        "jumlah": jumlah.toJson(),
        "panjang": panjang.toJson(),
      };
}

class Jumlah {
  Jumlah({
    required this.sisa,
    required this.perencanaan,
    required this.penanganan,
    required this.potensi,
  });

  String sisa;
  String perencanaan;
  String penanganan;
  String potensi;

  factory Jumlah.fromJson(Map<String, dynamic> json) => Jumlah(
        sisa: json["sisa"].toString(),
        perencanaan: json["perencanaan"].toString(),
        penanganan: json["penanganan"].toString(),
        potensi: json["potensi"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "sisa": sisa,
        "perencanaan": perencanaan,
        "penanganan": penanganan,
        "potensi": potensi,
      };
}

class Panjang {
  Panjang({
    required this.sisa,
    required this.perencanaan,
    required this.penanganan,
    required this.potensi,
  });

  double sisa;
  double perencanaan;
  double penanganan;
  double potensi;

  factory Panjang.fromJson(Map<String, dynamic> json) => Panjang(
        sisa: json["sisa"],
        perencanaan: json["perencanaan"],
        penanganan: json["penanganan"],
        potensi: json["potensi"],
      );

  Map<String, dynamic> toJson() => {
        "sisa": sisa,
        "perencanaan": perencanaan,
        "penanganan": penanganan,
        "potensi": potensi,
      };
}
