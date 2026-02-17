// This is ONLY for Student App - reads from Firebase
class Student {
  final String id;
  final String name;
  final String courseCode;
  final String courseName;
  final String department;
  final String section;
  final String room;
  final String bench;

  Student({
    required this.id,
    required this.name,
    required this.courseCode,
    required this.courseName,
    required this.department,
    required this.section,
    required this.room,
    required this.bench,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['StudentID']?.toString() ?? '',
      name: json['StudentName']?.toString() ?? '',
      courseCode: json['CourseCode']?.toString() ?? '',
      courseName: json['CourseName']?.toString() ?? '',
      department: json['Department']?.toString() ?? '',
      section: json['Section']?.toString() ?? '',
      room: json['RoomNo']?.toString() ?? '',
      bench: json['BenchNo']?.toString() ?? '',
    );
  }
}