class Grade {
  final int? id;
  final String subject;
  final String date;
  final int grade;

  Grade({this.id, required this.subject, required this.date, required this.grade});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'date': date,
      'grade': grade,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'] as int?,
      subject: map['subject'] as String,
      date: map['date'] as String,
      grade: map['grade'] as int,
    );
  }
}
