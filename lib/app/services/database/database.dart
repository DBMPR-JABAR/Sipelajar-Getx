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
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) {
        _database = db;
      },
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
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('version: $newVersion');
    if (oldVersion < newVersion) {
      await db.execute(
        '''
        DROP TABLE IF EXISTS draft_lubang''',
      );
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
        DROP TABLE IF EXISTS data_sup''',
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
      await db.execute(
        '''
        DROP TABLE IF EXISTS ruas''',
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
        DROP TABLE IF EXISTS user''',
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
        DROP TABLE IF EXISTS draft_penanganan''',
      );

      await db.execute(
        '''
        CREATE TABLE draft_penanganan(
          id INTEGER, 
          tanggal TEXT,
          ruas_jalan_id TEXT, 
          jumlah TEXT, 
          panjang TEXT, 
          lat TEXT, 
          long TEXT, 
          status TEXT,
          tanggal_rencana_penanganan TEXT,
          tanggal_penanganan TEXT,
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
    }
  }

  Future<void> truncateAllTable() async {
    final database = await DatabaseHelper.instance.database;
    await database.rawDelete('DELETE FROM user');
    await database.rawDelete('DELETE FROM ruas');
    await database.rawDelete('DELETE FROM data_sup');
    await database.rawDelete('DELETE FROM draft_lubang');
    await database.rawDelete('DELETE FROM draft_penanganan');
  }
}
