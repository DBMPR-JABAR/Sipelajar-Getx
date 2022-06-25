import 'package:sqflite/sqflite.dart';

import '../../../services/local/database.dart';

class UserModel {
  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.token,
    this.encryptedId,
  });

  final int? id;
  final String name;
  final String email;
  final String password;
  final String? token;
  final String? encryptedId;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int?,
        name: json['name'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        token: json['token'] as String?,
        encryptedId: json['encrypted_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'token': token,
        'encrypted_id': encryptedId,
      };

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, password: $password, token: $token, encryptedId: $encryptedId)';

  Future<void> save() async {
    final database = await DatabaseHelper.instance.database;
    await database.insert(
      'user',
      toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update() async {
    final database = await DatabaseHelper.instance.database;
    await database.update(
      'user',
      toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete() async {
    final database = await DatabaseHelper.instance.database;
    await database.delete(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<UserModel?> getUser() async {
    final database = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await database.query('user');
    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }
}
