import 'package:attendance_app/utils/models.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dash"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.account_circle,
                        size: 50.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Name',
                      style: TextStyle(
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "${USER?.name}",
                      style: const TextStyle(
                        letterSpacing: 2.0,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    const Text(
                      'Student ID',
                      style: TextStyle(
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "${USER?.id}",
                      style: const TextStyle(
                        letterSpacing: 2.0,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
