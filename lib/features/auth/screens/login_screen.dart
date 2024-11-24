import 'package:flutter/material.dart';
import 'package:journal/features/grades/screens/add_grade_form.dart';
import '../../../core/database/database_helper.dart';
import '../../grades/screens/grades_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Username')),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GradesScreen()));
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Переход до реєстрації
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
