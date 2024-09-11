import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_crud/data/data_base_service.dart';
import 'package:sqlite_crud/domain/todo.dart';

class TodoDB {
  final String tableName = 'todos';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "title" TEXT NOT NULL,
      "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
      "updated_at" INTEGER
    );""");
  }

  Future<int> create({required String title}) async {
    final database = await DataBaseService().dataBase;
    return await database.rawInsert(
      'INSERT INTO $tableName (title, created_at) VALUES (?, ?)',
      [title, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<List<ToDo>> fetchAll() async {
    final database = await DataBaseService().dataBase;
    final todos = await database.rawQuery(
      'SELECT * FROM $tableName ORDER BY COALESCE(updated_at, created_at)',
    );

    return todos.map((todo) => ToDo.fromSqfliteDatabase(todo)).toList();
  }

  Future<ToDo> fetchById(int id) async {
    final database = await DataBaseService().dataBase;
    final todo = await database.rawQuery(
      'SELECT * FROM $tableName WHERE id = ?',
      [id],
    );
    if (todo.isNotEmpty) {
      return ToDo.fromSqfliteDatabase(todo.first);
    } else {
      throw Exception('ToDo with id $id not found');
    }
  }

  Future<int> update({required int id, required String title}) async {
    final database = await DataBaseService().dataBase;
    return await database.update(
      tableName,
      {
        'title': title,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final database = await DataBaseService().dataBase;
    return await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final database = await DataBaseService().dataBase;
    await database.delete(tableName);
  }
}
