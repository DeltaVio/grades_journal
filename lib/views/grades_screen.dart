import 'package:flutter/material.dart';
import 'package:grades_journal/DatabaseHelper/database_helper.dart';
import 'package:intl/intl.dart';

class GradesScreen extends StatefulWidget {
  final int userId;  // Додаємо параметр userId, щоб передавати ідентифікатор користувача

  const GradesScreen({super.key, required this.userId});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  final dbHelper = DatabaseHelper();
  final subjectController = TextEditingController();
  final gradeController = TextEditingController();
  List<Map<String, dynamic>> grades = [];

  @override
  void initState() {
    super.initState();
    fetchGrades();
  }

  void fetchGrades() async {
    final data = await dbHelper.getGradesForUser(widget.userId); // Отримуємо оцінки для поточного користувача
    setState(() {
      grades = data;
    });
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date); // Конвертуємо рядок у DateTime
    return DateFormat('yyyy-MM-dd').format(dateTime); // Форматуємо дату у вигляді '2024-12-01'
  }

  // Оновлений метод для додавання оцінки з user_id
  void addGrade() async {
    if (subjectController.text.isNotEmpty &&
        gradeController.text.isNotEmpty &&
        int.tryParse(gradeController.text) != null) {
      await dbHelper.insertGrade({
        'user_id': widget.userId, // Додаємо user_id
        'subject': subjectController.text.trim(),
        'grade': int.parse(gradeController.text.trim()),
        'date': DateTime.now().toIso8601String(),
      });
      fetchGrades();
      subjectController.clear();
      gradeController.clear();
    }
  }

  void deleteGrade(int id) async {
    await dbHelper.deleteGrade(id);
    fetchGrades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Grades Journal")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      hintText: "Subject",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: gradeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Grade",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addGrade,
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];
                return ListTile(
                  title: Text("${grade['subject']}"),
                  subtitle: Text("Grade: ${grade['grade']}, Date: ${formatDate(grade['date'])}"), // Відображаємо дату
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteGrade(grade['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
