import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/student_model.dart';

class StudentProvider with ChangeNotifier {
  List<StudentModel> _students = [];

  List<StudentModel> get students => _students;

  File? _imageFile;
  File? get imageFile => _imageFile;

  void setImage(File? file) {
    _imageFile = file;
    notifyListeners();
  }

  void clearImage() {
    _imageFile = null;
    notifyListeners();
  }

  void loadStudents() {
    final box = Hive.box<StudentModel>('students');
    _students = box.values.toList();
    notifyListeners();
  }

  void addStudent(StudentModel student) {
    final box = Hive.box<StudentModel>('students');
    box.put(student.id, student);
    loadStudents();
  }

  void updateStudent(StudentModel updatedStudent) {
    final box = Hive.box<StudentModel>('students');
    if (box.containsKey(updatedStudent.id)) {
      box.put(updatedStudent.id, updatedStudent);
      loadStudents();
    }
  }

  void deleteStudent(String id) {
    final box = Hive.box<StudentModel>('students');
    box.delete(id);
    loadStudents();
  }
}
