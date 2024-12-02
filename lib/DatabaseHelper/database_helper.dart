import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'grades.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE grades (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        subject TEXT NOT NULL,
        grade INTEGER NOT NULL CHECK(grade >= 0 AND grade <= 100),
        date TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<int> deleteUser(int userId) async {
    final db = await database;
    await db.delete('grades', where: 'user_id = ?', whereArgs: [userId]);
    return await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  Future<int> insertGrade(Map<String, dynamic> grade) async {
    final db = await database;
    return await db.insert('grades', grade);
  }

  Future<int> deleteGrade(int gradeId) async {
    final db = await database;
    return await db.delete('grades', where: 'id = ?', whereArgs: [gradeId]);
  }

  Future<List<Map<String, dynamic>>> getGradesForUser(int userId) async {
    final db = await database;
    return await db.query(
      'grades',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getGradesBySubject(
      int userId, String subject) async {
    final db = await database;
    return await db.query(
      'grades',
      where: 'user_id = ? AND subject = ?',
      whereArgs: [userId, subject],
      orderBy: 'date DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getGradesByDate(
      int userId, String date) async {
    final db = await database;
    return await db.query(
      'grades',
      where: 'user_id = ? AND date = ?',
      whereArgs: [userId, date],
      orderBy: 'date DESC',
    );
  }

  Future<int> updateGrade(int id, Map<String, dynamic> updatedGrade) async {
    final db = await database;
    return await db.update(
      'grades',
      updatedGrade,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
