import 'package:sqflite/sqflite.dart';

import '../domain/entity/dog.dart';
import 'data_repo.dart';

final database = DataRepo().createTableInDB();

Future<List<Dog>> getAllDogs() async {
  final db = await database;
  // Запросите таблицу для всех собак.
  final List<Map<String, Object?>> dogMaps = await db.query('dogs');
  // Преобразуйте список полей каждой собаки в список объектов `Dog`.
  return [
    for (final {
          'id': id as int,
          'name': name as String,
          'age': age as int,
        } in dogMaps)
      Dog(id: id, name: name, age: age),
  ];
}

Future<void> insertDog(Dog dog) async {
  final db = await database;
  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateDog(Dog dog) async {
  final db = await database;
  await db.update(
    'dogs',
    dog.toMap(),
    // Убедитесь, что у собаки есть соответствующий id.
    where: 'id = ?',
    // Передайте id собаки как whereArg, чтобы предотвратить SQL-инъекцию.
    whereArgs: [dog.id],
  );
}

Future<void> deleteDog(int id) async {
  final db = await database;
  await db.delete(
    'dogs',
    where: 'id = ?',
    whereArgs: [id],
  );
}
