class Tables {
  static String userTableName = "users";

  static String userTable = ''' 
  CREATE TABLE IF NOT EXISTS $userTableName(
  userId INTEGER PRIMARY KEY AUTOINCREMENT,
  fullName TEXT,
  email TEXT,
  username TEXT UNIQUE,
  password TEXT
  )''';

  static String gradesTable = '''
  CREATE TABLE IF NOT EXISTS grades(
    gradeId INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER,
    date TEXT,
    subject TEXT,
    grade INTEGER,
    FOREIGN KEY (userId) REFERENCES users(userId)
  )
''';

}
