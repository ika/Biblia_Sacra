import 'package:bibliasacra/notes/nModel.dart';
import 'package:bibliasacra/notes/nProvider.dart';

NtProvider _ntProvider;

class NtQueries {
  final String tableName = 'notes';

  NtQueries() {
    _ntProvider = NtProvider();
  }

  Future<int> insertNote(NtModel model) async {
    final db = await _ntProvider.database;

    return await db.insert(tableName, model.toJson());
  }

  Future<int> updateNote(NtModel model) async {
    final db = await _ntProvider.database;

    return await db.update(tableName, model.toJson(),
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<List<NtModel>> getAllNotes() async {
    final db = await _ntProvider.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName ORDER BY id DESC''');

    List<NtModel> list = res.isNotEmpty
        ? res.map((tableName) => NtModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<List<NtModel>> getNoteById(int id) async {
    final db = await _ntProvider.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName WHERE id=?''', [id]);

    List<NtModel> list = res.isNotEmpty
        ? res.map((tableName) => NtModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<int> deleteNote(int id) async {
    final db = await _ntProvider.database;

    return await db.rawDelete('''DELETE FROM $tableName WHERE id=?''', [id]);
  }

  // Future<int> getNoteCount() async {
  //   final db = await _ntProvider.database;

  //   return Sqflite.firstIntValue(
  //       await db.rawQuery('''SELECT COUNT(*) FROM $tableName'''));
  // }
}
