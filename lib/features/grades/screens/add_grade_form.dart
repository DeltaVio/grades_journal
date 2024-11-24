import 'package:flutter/material.dart';

class AddGradeForm extends StatelessWidget {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  final Function(String subject, int grade) onSubmit;

  AddGradeForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Grade'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: subjectController,
            decoration: const InputDecoration(labelText: 'Subject'),
          ),
          TextField(
            controller: gradeController,
            decoration: const InputDecoration(labelText: 'Grade'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final subject = subjectController.text.trim();
            final gradeText = gradeController.text.trim();
            final grade = int.tryParse(gradeText);

            if (subject.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Subject cannot be empty')),
              );
              return;
            }

            if (grade == null || grade < 1 || grade > 12) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Grade must be between 1 and 12')),
              );
              return;
            }

            onSubmit(subject, grade);
            Navigator.pop(context);
          },
          child: const Text('Submit'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

