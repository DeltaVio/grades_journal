class Grade {
  final String username;
  final String subject;
  final int grade;
  final String date;

  Grade({required this.username, required this.subject, required this.grade, required this.date});

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      username: map['username'],
      subject: map['subject'],
      grade: map['grade'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'subject': subject,
      'grade': grade,
      'date': date,
    };
  }
}
