import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/student_model.dart';
import '../provider/student_provider.dart';

class StudentDetailScreen extends StatelessWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, _) {
          final student = provider.students.firstWhere(
            (s) => s.id == studentId,
          );

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade300,
                  Colors.deepPurple.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          student.imageUrl != null
                              ? FileImage(File(student.imageUrl!))
                              : null,
                      child:
                          student.imageUrl == null
                              ? const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      student.name ?? '',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 10.0,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      student.course ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.deepPurple.shade100,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailCard('Phone:', student.phone),
                    _buildDetailCard('Address:', student.address),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _showEditDialog(context, student),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          226,
                          222,
                          234,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Edit Student',
                        style: TextStyle(
                          fontSize: 18,
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
    );
  }

  Widget _buildDetailCard(String label, String? value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white.withAlpha(230),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              '$label ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple,
              ),
            ),
            Expanded(
              child: Text(
                value ?? 'N/A',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, StudentModel student) {
    final phoneController = TextEditingController(text: student.phone);
    final addressController = TextEditingController(text: student.address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Phone & Address'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedStudent = StudentModel(
                  id: student.id,
                  name: student.name,
                  course: student.course,
                  imageUrl: student.imageUrl,
                  phone: phoneController.text.trim(),
                  address: addressController.text.trim(),
                );
                Provider.of<StudentProvider>(
                  context,
                  listen: false,
                ).updateStudent(updatedStudent);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student details updated')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
