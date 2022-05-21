import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/task_model.dart';

class DBProvider {
  //constructor
  DBProvider._();
  static final DBProvider dataBase = DBProvider._();
  static Database _database;

  //getter
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDataBase();
    return _database;
  }

  //DB initialiser
  initDataBase() async {
    return await openDatabase(join(await getDatabasesPath(), 'todo_app_db.db'),
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, creationDate TEXT)
      ''');
    }, version: 1);
  }

  addNewTask(Task newTask) async {
    final db = await dataBase;

    db.insert("tasks", newTask.toMap(),
        ConflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getTask() async {
    final db = await database;
    var res = await db.query("tasks");
    if (res.length == 0) {
      return Null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }

  void insert(String s, Map<String, dynamic> map,
      {required ConflictAlgorithm ConflictAlgorithm}) {}
}
