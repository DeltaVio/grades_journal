
import 'package:grades_journal/DatabaseHelper/tables.dart';

import '../Models/users.dart';
import 'connection.dart';

class Repository{
  final DatabaseHelper databaseHelper = DatabaseHelper();

  //Login
  Future<bool> authenticate(Users users)async{
    final db = await databaseHelper.initDB();
    final authenticated = await db.query(Tables.userTableName,where: 'username = ? AND password = ?', whereArgs: [users.username, users.password]);
    if(authenticated.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  //Sign up
  Future<int> registerUser(Users users)async{
    final db = await databaseHelper.initDB();
    //First check whether the entered user has already exists or not then create it.
    final isDuplicateUser = await db.query(Tables.userTableName, where: 'username = ?',whereArgs: [users.username]);
    if(isDuplicateUser.isNotEmpty){
      return 0;
    }else{
      //If not create the user
      return await db.insert(Tables.userTableName, users.toMap());
    }
  }

  Future<Users> getLoggedInUser(String username)async{
    final db = await databaseHelper.initDB();
    final res = await db.query(Tables.userTableName,where: 'username = ?',whereArgs: [username]);
    if(res.isNotEmpty){
      return Users.fromMap(res.first);
    }else{
      throw Exception("User $username not found");
    }
  }

  // Add grade
  Future<int> addGrade(int userId, String date, String subject, int grade) async {
    final db = await databaseHelper.initDB();
    return await db.insert('grades', {
      'userId': userId,
      'date': date,
      'subject': subject,
      'grade': grade,
    });
  }

  // Get grades
  Future<List<Map<String, dynamic>>> getGrades(int userId) async {
    final db = await databaseHelper.initDB();
    return await db.query('grades', where: 'userId = ?', whereArgs: [userId]);
  }

  // Delete grades
  Future<int> deleteGrade(int gradeId) async {
    final db = await databaseHelper.initDB();
    return await db.delete('grades', where: 'gradeId = ?', whereArgs: [gradeId]);
  }

}