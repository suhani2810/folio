import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'folio.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE folders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE documents(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            folderId INTEGER,
            name TEXT,
            createdAt TEXT
          )
        ''');

      },
    );
  }
}