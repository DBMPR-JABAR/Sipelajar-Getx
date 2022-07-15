import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'sipelajar.db'),
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) {
        _database = db;
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      ''' 
      CREATE TABLE draft_lubang(
        id INTEGER PRIMARY KEY, 
        tanggal TEXT,
        ruas_jalan_id TEXT, 
        jumlah TEXT, 
        panjang TEXT, 
        lat TEXT, 
        long TEXT, 
        lokasi_kode TEXT, 
        lokasi_km TEXT, 
        lokasi_m TEXT, 
        kategori TEXT, 
        image TEXT, 
        lajur TEXT, 
        kategori_kedalaman TEXT, 
        keterangan TEXT,
        potensi_lubang INTEGER,
        uploaded INTEGER
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
        CREATE TABLE user(
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          email TEXT, 
          token TEXT,
          encrypted_id TEXT,
          password TEXT,
          role TEXT
          )''',
    );
    await db.execute(
      '''
        CREATE TABLE draft_data_penanganan_from_server(
          id INTEGER UNIQUE, 
          ruas_jalan_id TEXT,
          nama_ruas_jalan TEXT, 
          kategori TEXT, 
          kategori_kedalaman TEXT, 
          jumlah TEXT, 
          panjang TEXT, 
          tanggal TEXT,
          tanggal_rencana_penanganan TEXT,
          tanggal_penanganan TEXT,
          image TEXT, 
          image_penanganan TEXT, 
          lat TEXT, 
          long TEXT, 
          lokasi_kode TEXT, 
          lokasi_km TEXT, 
          lokasi_m TEXT, 
          monitoring_lubang_survei_id TEXT,
          status TEXT,
          keterangan TEXT,
          lajur TEXT,
          created_by TEXT,
          updated TEXT 
          )''',
    );
  }
  // NOT USED NOW FOR NEXT UPDATE TABLE
  // Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < newVersion) {}
  // }

  Future<void> truncateAllTable() async {
    final database = await DatabaseHelper.instance.database;
    await database.rawDelete('DELETE FROM user');
    await database.rawDelete('DELETE FROM ruas');
    await database.rawDelete('DELETE FROM draft_lubang');
    await database.rawDelete('DELETE FROM draft_data_penanganan_from_server');
  }
}
