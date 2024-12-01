import 'package:flutter/material.dart';
import 'package:grades_journal/DatabaseHelper/database_helper.dart';
import 'grades_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  void loginUser() async {
    if (formKey.currentState!.validate()) {
      final db = await dbHelper.database;

      // Retrieve the user from the database by username and password
      final user = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [
          usernameController.text.trim(),
          passwordController.text.trim(),
        ],
      );

      if (user.isNotEmpty) {
        // Convert the id value to type int
        final userId = user.first['id'] as int;

        // Navigate to the grades screen and pass the userId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GradesScreen(userId: userId), // pass the userId
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username or password")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: "Username"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loginUser,
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
