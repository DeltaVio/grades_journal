import 'package:flutter/material.dart';
import 'add_grade_form.dart'; // Імпортуємо форму додавання оцінки
import '../../../core/database/database_helper.dart';
import '../../../models/grade_model.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  late Future<List<Grade>> gradesFuture;

  @override
  void initState() {
    super.initState();
    gradesFuture = fetchGrades();
  }

  Future<List<Grade>> fetchGrades() async {
    return await DatabaseHelper.instance.fetchGrades();
  }

  void addGrade(String subject, int grade) async {
    final newGrade = Grade(
      subject: subject,
      date: DateTime.now().toString(),
      grade: grade,
    );
    await DatabaseHelper.instance.insertGrade(newGrade);
    setState(() {
      gradesFuture = fetchGrades();
    });
  }

  void showAddGradeForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddGradeForm(
          onSubmit: (subject, grade) {
            addGrade(subject, grade);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grades History')),
      body: FutureBuilder<List<Grade>>(
        future: gradesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching grades'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No grades found'));
          } else {
            final grades = snapshot.data!;
            return ListView.builder(
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];
                return ListTile(
                  title: Text('${grade.subject} - ${grade.grade}'),
                  subtitle: Text(grade.date),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddGradeForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
