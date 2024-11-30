import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/AuthBloc/auth_bloc.dart';
import '../DatabaseHelper/repository.dart';
import '../constants/env.dart';
import 'add_grade_screen.dart';
import 'login_screen.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = Repository();

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Env.gotoReplacement(context, const LoginScreen());
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          final userId = state.users.userId!;

          return Scaffold(
            appBar: AppBar(
              title: Text("Grades: ${state.users.fullName}"),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(UnAuthenticatedEvent());
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: FutureBuilder<List<Map<String, dynamic>>>(
              future: repository.getGrades(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final grades = snapshot.data!;
                  return ListView.builder(
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      final grade = grades[index];
                      return ListTile(
                        title: Text(grade['subject']),
                        subtitle: Text("Date: ${grade['date']} | Grade: ${grade['grade']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await repository.deleteGrade(grade['gradeId']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Grade deleted")),
                            );
                            // Оновити екран після видалення
                            (context as Element).reassemble();
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No grades available"));
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddGradeScreen(userId: userId),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        }
        return const Center(child: Text("Loading user data..."));
      },
    );
  }
}
