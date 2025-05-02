import 'package:hive/hive.dart';

part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? course;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? address;

  @HiveField(5)
  String? imageUrl;

  StudentModel({
    required this.id,
    this.name,
    this.course,
    this.imageUrl,
    this.phone,
    this.address,
  });
}
