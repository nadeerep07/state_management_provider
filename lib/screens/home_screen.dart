import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management_pro/provider/student_provider.dart';
import 'package:student_management_pro/screens/student_detail_screen.dart';
import 'package:student_management_pro/widgets/add_student_fab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _confirmDelete(BuildContext context, String studentId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
              'Are you sure you want to delete this student?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<StudentProvider>(
                    context,
                    listen: false,
                  ).deleteStudent(studentId);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Student has been deleted')),
                  );
                },
                child: const Text('Yes'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        leading: const Icon(Icons.school, size: 30),
        title: const Text('Student Management'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child:
            studentProvider.students.isEmpty
                ? const Center(child: Text('No students added yet.'))
                : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: studentProvider.students.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final student = studentProvider.students[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    StudentDetailScreen(studentId: student.id),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        color: Colors.teal.shade100,
                        shadowColor: Colors.black.withAlpha(50),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    student.imageUrl != null
                                        ? FileImage(File(student.imageUrl!))
                                        : null,
                                child:
                                    student.imageUrl == null
                                        ? const Icon(Icons.person, size: 30)
                                        : null,
                              ),
                              Text(
                                student.name ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                student.course ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(
                                onPressed:
                                    () => _confirmDelete(context, student.id),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: AddStudentFAB(),
    );
  }
}
