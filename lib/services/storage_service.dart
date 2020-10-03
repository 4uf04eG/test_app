import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_app/models/cat_fact.dart';

class StorageService {
  static final _tableName = "Favorites";
  static final _dbName = "test.db";

  static final _columnFact = "text";

  static Database _database;

  static Future<List<CatFact>> getAllCatFacts() async {
    final db = await _getDatabase();
    final data = await db.query(_tableName);
    return data?.map((e) => CatFact(e[_columnFact]))?.toList() ?? [];
  }

  static void saveCatFact(CatFact fact) async {
    final db = await _getDatabase();
    await db.insert(_tableName, {_columnFact: fact.text},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static void removeCatFact(CatFact fact) async {
    final db = await _getDatabase();
    await db.delete(_tableName, where: "$_columnFact = ?", whereArgs: [fact.text]);
  }

  static Future<Database> _getDatabase() async {
    if (_database != null) return _database;

    var path = await _getDatabasePath();

    return _database =
    await openDatabase(path, version: 1, onCreate: _populateDb);
  }

  static void _populateDb(Database db, int version) async {
    await db.execute('CREATE TABLE $_tableName '
        '($_columnFact TEXT PRIMARY KEY)');
  }

  static Future<String> _getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _dbName);

    if (!await Directory(dirname(path)).exists()) {
      await Directory(dirname(path)).create(recursive: true);
    }

    return path;
  }
}