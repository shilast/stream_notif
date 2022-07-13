import 'package:path_provider/path_provider.dart';
import 'package:path/path.Dart';
import 'package:collection/collection.Dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DB {
  static Future<Database> getDatabase() async {
    // getDbPathは自作メソッド
    final path = await getDbPath();
    final database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE ..省略..');
    });
    return database;
  }

  static Future<String> getDbPath() async {
    var dbFilePath = '';

    if (Platform.isAndroid) {
      // Androidであれば「getDatabasesPath」を利用
      dbFilePath = await getDatabasesPath();
    } else if (Platform.isIOS) {
      // iOSであれば「getLibraryDirectory」を利用
      final dbDirectory = await getLibraryDirectory();
      dbFilePath = dbDirectory.path;
    } else {
      // プラットフォームが判別できない場合はExceptionをthrow
      // 簡易的にExceptionをつかったが、自作Exceptionの方がよいと思う。
      throw Exception('Unable to determine platform.');
    }
    // 配置場所のパスを作成して返却
    final path = join(dbFilePath, 'test.db');
    return path;
  }

//DBへ追加
  static Future insertNote(DB note) async {
    final Database db = await DB.getDatabase();
    await db.insert(
      'note',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//DB参照
  static Future<List<DB>> getNotes() async {
    final Database db = await DB.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('note');
    return List.generate(maps.length, (i) {
      return DB(
        id: maps[i]['id'],
        text: maps[i]['text'],
        priority: maps[i]['priority'],
      );
    });
  }

//更新
  static Future<void> updateMemo(DB note) async {
    final db = await DB.getDatabase();
    await db.update(
      'note',
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

//削除
  static Future<void> deleteNote(int id) async {
    final db = await DB.getDatabase();
    await db.delete(
      'note',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
