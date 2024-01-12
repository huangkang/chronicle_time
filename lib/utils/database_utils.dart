import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "hkDatabase.db";
  static const _databaseVersion = 1;

  //记录表
  static const recordTable = 'record';
  static const photoTable = 'photo';

  /*id*/
  static const id = 'id';

  /*记录名称*/
  static const recordName = 'recordName';

  /*拍摄间隔*/
  static const recordInterval = 'recordInterval';

  /*帧数*/
  static const recordFps = 'recordFps';

  /*记录拍摄时间*/
  static const recordCreateTime = 'recordCreateTime';

  /*记录照片地址*/
  static const recordPhotoPath = 'recordPhotoPath';

  /*记录视频地址*/
  static const recordVideoPath = 'recordVideoPath';

  /*照片id*/
  static const recordId = 'recordId';

  /*照片地址*/
  static const photoPath = 'photoPath';

  /*照片拍摄时间*/
  static const photoTime = 'photoTime';

  // 单例模式
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = await getDatabasesPath();
    String fullPath = join(path, _databaseName);
    return await openDatabase(fullPath,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $recordTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $recordName TEXT NOT NULL,
            $recordInterval INTEGER NOT NULL,
            $recordFps INTEGER NOT NULL,
            $recordCreateTime INTEGER NOT NULL,
            $recordPhotoPath TEXT,
            $recordVideoPath TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $photoTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $recordId INTEGER NOT NULL,
            $photoPath TEXT NOT NULL,
            $photoTime INTEGER NOT NULL
          )
          ''');
  }

  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<int> update(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db
        .update(tableName, row, where: 'id = ?', whereArgs: [row['id']]);
  }

  Future<int> delete(String tableName, int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePhoto(int id) async {
    Database db = await instance.database;
    return await db
        .delete(photoTable, where: '$recordId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> queryRows(
      String tableName, String name, int id) async {
    Database db = await instance.database;
    return await db.query(tableName, where: '$name = ?', whereArgs: [id]);
  }
}
