import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataRepo {
// Установите путь к базе данных. Примечание: Использование функции `join` из
// пакета `path` является лучшей практикой, чтобы гарантировать, что путь
// корректно построен для каждой платформы.

// Когда база данных будет создана впервые, создайте таблицу для хранения собак.

// Выполняем команду CREATE TABLE в базе данных.

// Установите версию. Это выполняет функцию onCreate и предоставляет путь
// для выполнения обновлений и понижений базы данных.

  Future<Database> createTableInDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
  }
}
