import 'dart:convert';

LoginResponModel loginResponModelFromJson(String str) =>
    LoginResponModel.fromJson(json.decode(str));

String loginResponModelToJson(LoginResponModel data) =>
    json.encode(data.toJson());

class LoginResponModel {
  LoginResponModel({
    required this.status,
    required this.data,
  });

  String status;
  Data data;

  factory LoginResponModel.fromJson(Map<String, dynamic> json) =>
      LoginResponModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({this.token, this.user, this.message});

  Token? token;
  User? user;
  String? message;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json["message"] == null ? Token.fromJson(json["token"]) : null,
      user: json["message"] == null ? User.fromJson(json["user"]) : null,
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token!.toJson(),
        "user": user!.toJson(),
      };
}

class Token {
  Token({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  String accessToken;
  String tokenType;
  int expiresIn;

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json["access_token"],
      tokenType: json["token_type"],
      expiresIn: json["expires_in"],
    );
  }

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
      };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.internalRoleId,
    required this.sup,
    required this.blokir,
    required this.ruas,
    required this.encryptedId,
  });

  int id;
  String name;
  String email;
  String role;
  int internalRoleId;
  String? sup;
  String? blokir;
  List<Ruas> ruas;
  String? encryptedId;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      internalRoleId: json["internal_role_id"],
      sup: json["sup"],
      blokir: json["blokir"],
      ruas: List<Ruas>.from(json["ruas"].map((x) => Ruas.fromJson(x))),
      encryptedId: json["encrypted_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "internal_role_id": internalRoleId,
        "sup": sup,
        "blokir": blokir,
        "ruas": List<dynamic>.from(ruas.map((x) => x.toJson())),
        "encrypted_id": encryptedId,
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
