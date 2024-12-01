import 'package:flutter/material.dart';
import 'package:grades_journal/DatabaseHelper/database_helper.dart';
import 'package:intl/intl.dart';

class AddGradeScreen extends StatefulWidget {
  final int userId;
  final Function refreshGrades; // Функція для оновлення списку оцінок

  const AddGradeScreen({
    super.key,
    required this.userId,
    required this.refreshGrades,
  });

  @override
  State<AddGradeScreen> createState() => _AddGradeScreenState();
}

class _AddGradeScreenState extends State<AddGradeScreen> {
  final subjectController = TextEditingController();
  final gradeController = TextEditingController();
  DateTime? selectedDate; // Дата, вибрана користувачем

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void addGrade() async {
    if (subjectController.text.isNotEmpty &&
        gradeController.text.isNotEmpty &&
        int.tryParse(gradeController.text) != null &&
        selectedDate != null) {
      final dbHelper = DatabaseHelper();

      final grade = {
        'user_id': widget.userId,
        'subject': subjectController.text,
        'grade': int.parse(gradeController.text),
        'date': DateFormat('yyyy-MM-dd').format(selectedDate!),
      };

      await dbHelper.insertGrade(grade);

      // Оновлюємо список оцінок
      widget.refreshGrades();

      // Повертаємось на попередній екран
      Navigator.pop(context);
    } else {
      // Показати повідомлення, якщо дані неповні
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields!")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Grade"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                hintText: "Subject",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: gradeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Grade",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => selectDate(context),
              child: Text(
                selectedDate == null
                    ? "Select Date"
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: addGrade,
              child: const Text("Add Grade"),
            ),
          ],
        ),
      ),
    );
  }
}
