import 'package:flutter/material.dart';
import '../DatabaseHelper/repository.dart';

class AddGradeScreen extends StatefulWidget {
  final int userId;

  const AddGradeScreen({required this.userId, super.key});

  @override
  State<AddGradeScreen> createState() => _AddGradeScreenState();
}

class _AddGradeScreenState extends State<AddGradeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _subjectController = TextEditingController();
  final _gradeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repository = Repository();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Grade")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: "Date"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a date";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: "Subject"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a subject";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _gradeController,
                decoration: const InputDecoration(labelText: "Grade"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a grade";
                  }
                  final grade = int.tryParse(value);
                  if (grade == null || grade < 1 || grade > 12) {
                    return "Grade must be between 1 and 12";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await repository.addGrade(
                      widget.userId,
                      _dateController.text,
                      _subjectController.text,
                      int.parse(_gradeController.text),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Grade added")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add Grade"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
