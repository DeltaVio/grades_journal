import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:grades_journal/DatabaseHelper/database_helper.dart';
import 'add_grade_screen.dart';
import 'delete_account_screen.dart';
import 'login_screen.dart';
import '../Helpers/auth_notifier.dart';

class GradesScreen extends ConsumerStatefulWidget {
  final int userId;

  const GradesScreen({super.key, required this.userId});

  @override
  ConsumerState<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends ConsumerState<GradesScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> grades = [];

  @override
  void initState() {
    super.initState();
    fetchGrades();
  }

  void fetchGrades() async {
    print("User ID: ${widget.userId}");
    print("Fetching grades...");
    final data = await dbHelper.getGradesForUser(widget.userId);
    setState(() {
      grades = data;
    });
    print("Grades fetched: $grades");
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void deleteGrade(int id) async {
    await dbHelper.deleteGrade(id);
    fetchGrades();
  }

  void logout() {
    ref.read(authProvider.notifier).logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void showLogoutMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0, 80.0, 0.0, 0.0),
      items: [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteAccountScreen(userId: widget.userId),
                ),
              );
            },
            child: const Text("Delete Account"),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grades Journal"),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: logout, // Виклик методу logout
          tooltip: "Logout",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: showLogoutMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];
                return ListTile(
                  title: Text("${grade['subject']}"),
                  subtitle: Text(
                    "Grade: ${grade['grade']}, Date: ${formatDate(grade['date'])}",
                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddGradeScreen(
                userId: widget.userId,
                refreshGrades: fetchGrades,
              ),
            ),
          );
          fetchGrades();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
