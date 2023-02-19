import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:bibliasacra/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Bookmarks database helper

class HlProvider {
  final String dataBaseName = Constants.hltsDbname;
  final String tableName = 'hlts_table';

  static HlProvider _dbProvider;
  static Database _database;

  HlProvider._createInstance();

  factory HlProvider() {
    _dbProvider ??= HlProvider._createInstance();
    return _dbProvider;
  }

  Future<Database> get database async {
    _database ??= await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);

    //var db = await databaseFactory.openDatabase(path);
    //var db = await openDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        await db.execute('''
                CREATE TABLE IF NOT EXISTS $tableName (
                    id INTEGER PRIMARY KEY,
                    title TEXT DEFAULT '',
                    subtitle TEXT DEFAULT '',
                    lang TEXT DEFAULT '',
                    version INTEGER DEFAULT 0,
                    abbr TEXT DEFAULT '',
                    book INTEGER DEFAULT 0,
                    chapter INTEGER DEFAULT 0,
                    verse INTEGER DEFAULT 0,
                    name TEXT DEFAULT '',
                    bid INTEGER DEFAULT 0
                )
            ''');
      },
    );
    //return db;
  }

  Future close() async {
    return _database.close();
  }
}
