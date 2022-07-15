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
  List<NewsData> data;

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) =>
      NewsResponseModel(
        success: json["success"],
        message: json["message"],
        data:
            List<NewsData>.from(json["data"].map((x) => NewsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NewsData {
  NewsData({
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

  factory NewsData.fromJson(Map<String, dynamic> json) => NewsData(
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
      };
}
