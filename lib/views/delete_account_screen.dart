import 'package:flutter/material.dart';
import 'package:grades_journal/DatabaseHelper/database_helper.dart';
import 'login_screen.dart';  // Для повернення на екран логіну

class DeleteAccountScreen extends StatefulWidget {
  final int userId;  // Ідентифікатор користувача

  const DeleteAccountScreen({super.key, required this.userId});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final dbHelper = DatabaseHelper();

  // Функція для видалення користувача
  void deleteUser() async {
    final db = await dbHelper.database;
    await db.delete(
      'users', // Видаляємо користувача з таблиці 'users'
      where: 'id = ?',
      whereArgs: [widget.userId],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User deleted successfully")),
    );

    // Повертаємося на екран логіну
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Підтвердження видалення через AlertDialog
  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Закриваємо діалог без видалення
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteUser(); // Видаляємо користувача
                Navigator.pop(context); // Закриваємо діалог після видалення
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: showDeleteConfirmationDialog,
              child: const Text("Delete Account"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
