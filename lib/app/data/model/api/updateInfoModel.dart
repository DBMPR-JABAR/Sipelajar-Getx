import 'dart:convert';

UpdateInfoModel updateInfoModelFromJson(String str) =>
    UpdateInfoModel.fromJson(json.decode(str));

String updateInfoModelToJson(UpdateInfoModel data) =>
    json.encode(data.toJson());

class UpdateInfoModel {
  UpdateInfoModel({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.build,
    required this.buildSignature,
    required this.releaseNotes,
    required this.url,
  });

  String appName;
  String packageName;
  String version;
  String build;
  String buildSignature;
  String releaseNotes;
  String url;

  factory UpdateInfoModel.fromJson(Map<String, dynamic> json) =>
      UpdateInfoModel(
        appName: json["appName"],
        packageName: json["packageName"],
        version: json["version"],
        build: json["build"],
        buildSignature: json["buildSignature"],
        releaseNotes: json["ReleaseNotes"],
        url: json["downloadUrl"],
      );

  Map<String, dynamic> toJson() => {
        "appName": appName,
        "packageName": packageName,
        "version": version,
        "build": build,
        "buildSignature": buildSignature,
        "ReleaseNotes": releaseNotes,
        "downloadUrl": url,
      };
}
