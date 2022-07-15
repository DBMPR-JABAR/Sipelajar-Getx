import 'package:sipelajar/app/helper/utils.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/database/database.dart';

class RuasJalanModel {
  RuasJalanModel({
    this.id,
    required this.namaRuasJalan,
    required this.idRuasJalan,
  });

  final int? id;
  final String namaRuasJalan;
  final String idRuasJalan;

  factory RuasJalanModel.fromJson(Map<String, dynamic> json) => RuasJalanModel(
        id: json['id'] as int,
        namaRuasJalan: json['nama_ruas_jalan'] as String,
        idRuasJalan: json['id_ruas_jalan'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama_ruas_jalan': namaRuasJalan,
        'id_ruas_jalan': idRuasJalan,
      };

  @override
  String toString() =>
      'RuasJalan(id: $id, namaRuas: $namaRuasJalan, idRuasJalan: $idRuasJalan)';

  Future<void> save() async {
    final database = await DatabaseHelper.instance.database;
    await database.insert(
      'ruas',
      toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> saveMany(List<RuasJalanModel> ruasJalan) async {
    final database = await DatabaseHelper.instance.database;
    try {
      for (var i = 0; i < ruasJalan.length; i++) {
        await database.insert(
          'ruas',
          ruasJalan[i].toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<void> update() async {
    final database = await DatabaseHelper.instance.database;
    await database.update(
      'ruas',
      toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<RuasJalanModel>> getAll() async {
    final database = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await database.query('ruas');
    return List.generate(maps.length, (i) {
      return RuasJalanModel(
        namaRuasJalan: maps[i]['nama_ruas_jalan'] as String,
        idRuasJalan: maps[i]['id_ruas_jalan'] as String,
      );
    });
  }

  static Future<void> deleteAll() async {
    final database = await DatabaseHelper.instance.database;
    await database.delete('ruas');
  }
}
