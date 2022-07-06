import 'dart:convert';

NewsResponseModel newsResponseModelFromJson(String str) =>
    NewsResponseModel.fromJson(json.decode(str));

String newsResponseModelToJson(NewsResponseModel data) =>
    json.encode(data.toJson());

class NewsResponseModel {
  NewsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) =>
      NewsResponseModel(
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
    required this.id,
    required this.title,
    required this.slug,
    required this.pathUrl,
    required this.description,
    required this.content,
    required this.publishedAt,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAtForHuman,
    required this.publishedBy,
  });

  int id;
  String title;
  String slug;
  String pathUrl;
  String description;
  String content;
  String publishedAt;
  int userId;
  String createdAt;
  String updatedAt;
  String publishedAtForHuman;
  PublishedBy publishedBy;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        pathUrl: json["path_url"],
        description: json["description"],
        content: json["content"],
        publishedAt: json["published_at"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        publishedAtForHuman: json["publishedAtForHuman"],
        publishedBy: PublishedBy.fromJson(json["published_by"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "path_url": pathUrl,
        "description": description,
        "content": content,
        "published_at": publishedAt,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "publishedAtForHuman": publishedAtForHuman,
        "published_by": publishedBy.toJson(),
      };
}

class PublishedBy {
  PublishedBy({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.kodeOtp,
    required this.role,
    required this.internalRoleId,
    required this.sup,
    required this.supId,
    required this.uptdId,
    required this.blokir,
    required this.isDelete,
    required this.fcmToken,
    required this.twoFactorSecret,
    required this.twoFactorRecoveryCodes,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String email;
  String emailVerifiedAt;
  dynamic kodeOtp;
  String role;
  int internalRoleId;
  dynamic sup;
  dynamic supId;
  dynamic uptdId;
  String blokir;
  dynamic isDelete;
  String fcmToken;
  dynamic twoFactorSecret;
  dynamic twoFactorRecoveryCodes;
  String createdAt;
  dynamic updatedAt;

  factory PublishedBy.fromJson(Map<String, dynamic> json) => PublishedBy(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        kodeOtp: json["kode_otp"],
        role: json["role"],
        internalRoleId: json["internal_role_id"],
        sup: json["sup"],
        supId: json["sup_id"],
        uptdId: json["uptd_id"],
        blokir: json["blokir"],
        isDelete: json["is_delete"],
        fcmToken: json["fcm_token"],
        twoFactorSecret: json["two_factor_secret"],
        twoFactorRecoveryCodes: json["two_factor_recovery_codes"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "kode_otp": kodeOtp,
        "role": role,
        "internal_role_id": internalRoleId,
        "sup": sup,
        "sup_id": supId,
        "uptd_id": uptdId,
        "blokir": blokir,
        "is_delete": isDelete,
        "fcm_token": fcmToken,
        "two_factor_secret": twoFactorSecret,
        "two_factor_recovery_codes": twoFactorRecoveryCodes,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
