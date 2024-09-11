import 'package:path/path.dart';  // Добавлен импорт пакета path
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_crud/data/todo_db.dart';


class DataBaseService {
  Database? _database;

  Future<String> get fullPath async {
    const name = 'to.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<Database> get dataBase async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<void> create(Database database, int version) async{
    return await TodoDB().createTable(database);
  }
}
