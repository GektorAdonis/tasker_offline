import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:tasker_offline/task.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY,
        title TEXT,
        date TEXT,
        isComplete INTEGER
      )
''');
  }

  Future<List<Task>> getTasks() async {
    Database db = await instance.database;
    var tasks = await db.query('tasks');
    var doneTasks = [];
    List<Task> taskList = tasks.isNotEmpty
        ? tasks.map((task) => Task.fromMap(task)).toList()
        : [];
    for (var task in taskList) {
      if (task.isComplete == 1) {
        doneTasks.add(task);
      }
    }
    taskList.removeWhere((task) => doneTasks.contains(task));
    return taskList;
  }

  Future<int> add(Task task) async {
    Database db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<int> update(Task task) async {
    Database db = await instance.database;
    return await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
