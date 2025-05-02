import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_management_pro/model/student_model.dart';
import 'package:student_management_pro/provider/student_provider.dart';

class AddStudentFAB extends StatelessWidget {
  AddStudentFAB({super.key});

  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final courseCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  Future<void> _pickImage(BuildContext context) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      Provider.of<StudentProvider>(
        context,
        listen: false,
      ).setImage(File(picked.path));
    }
  }

  void _clearForm(BuildContext context) {
    nameCtrl.clear();
    courseCtrl.clear();
    phoneCtrl.clear();
    addressCtrl.clear();
    Provider.of<StudentProvider>(context, listen: false).clearImage();
  }

  void _submitForm(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      final student = StudentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameCtrl.text.trim(),
        course: courseCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        address: addressCtrl.text.trim(),
        imageUrl: provider.imageFile?.path,
      );

      provider.addStudent(student);
      provider.clearImage();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student added successfully')),
      );
    }
  }

  void _openBottomSheet(BuildContext context) {
    _clearForm(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Consumer<StudentProvider>(
              builder:
                  (context, provider, _) => SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Add Student',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _pickImage(context),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                provider.imageFile != null
                                    ? FileImage(provider.imageFile!)
                                    : null,
                            child:
                                provider.imageFile == null
                                    ? const Icon(Icons.camera_alt, size: 30)
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Personal Info'),
                        _buildTextField(
                          'Name',
                          nameCtrl,
                          Icons.person,
                          _requiredValidator,
                        ),
                        _buildTextField(
                          'Course',
                          courseCtrl,
                          Icons.book,
                          _requiredValidator,
                        ),
                        const SizedBox(height: 16),
                        _buildSectionTitle('Contact Info'),
                        _buildTextField(
                          'Phone',
                          phoneCtrl,
                          Icons.phone,
                          _phoneValidator,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildTextField(
                          'Address',
                          addressCtrl,
                          Icons.home,
                          _requiredValidator,
                        ),
                        const SizedBox(height: 20),
                        _buildSubmitButton(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    String? Function(String?) validator, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.check),
      label: const Text('Add Student'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        minimumSize: const Size.fromHeight(45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => _submitForm(context),
    );
  }

  String? _requiredValidator(String? value) {
    return (value == null || value.trim().isEmpty) ? 'Field is required' : null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter phone number';
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter valid 10-digit phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openBottomSheet(context),
      icon: const Icon(Icons.person_add),
      label: const Text('Add Student'),
      backgroundColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
