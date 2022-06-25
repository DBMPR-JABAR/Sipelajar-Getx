import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'sipelajar.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        email TEXT, 
        token TEXT,
        encrypted_id TEXT,
        password TEXT
        )''',
    );

    await db.execute(
      '''
      CREATE TABLE ruas(
        id INTEGER PRIMARY KEY, 
        id_ruas_jalan TEXT, 
        nama_ruas_jalan TEXT
        )''',
    );

    await db.execute(
      '''
      CREATE TABLE data_sup(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        uptd_id TEXT, 
        kd_sup TEXT
        )''',
    );
  }
}
