import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';

class SheetsService {
  // TODO: Replace with your actual values
  final String _spreadsheetId = '1tPZ8Wim8Kony5JthYf9aVhxvDRLshP5Kv1-cdA_TiuE';
  final String _sheetName = 'Sheet1';
  final String _apiKey = 'AIzaSyBQS02d-enQ6ugCCKUgjyzt_PHt8Zwq6wo';
  
  Map<String, Student>? _cache;
  DateTime? _lastFetch;

  Future<Student?> findStudentById(String id) async {
    final data = await _getData();
    return data[id];
  }

  Future<Map<String, Student>> _getData() async {
    if (_cache != null && _lastFetch != null) {
      if (DateTime.now().difference(_lastFetch!).inMinutes < 30) {
        return _cache!;
      }
    }

    try {
      final url = 'https://sheets.googleapis.com/v4/spreadsheets/$_spreadsheetId/values/$_sheetName?key=$_apiKey';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rows = data['values'] as List<dynamic>;
        
        if (rows.isEmpty) return await _loadFromDisk();

        final headers = rows[0].map((h) => h.toString()).toList();
        final result = <String, Student>{};

        for (var i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.length >= headers.length) {
            final Map<String, dynamic> map = {};
            for (var j = 0; j < headers.length; j++) {
              map[headers[j]] = row[j].toString();
            }
            final student = Student.fromJson(map);
            result[student.id] = student;
          }
        }

        _cache = result;
        _lastFetch = DateTime.now();
        await _saveToDisk(result);
        return result;
      }
    } catch (e) {
      print('Network error: $e');
    }

    return await _loadFromDisk();
  }

  Future<void> _saveToDisk(Map<String, Student> data) async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, String>{};
    data.forEach((key, student) {
      map[key] = json.encode({
        'id': student.id,
        'name': student.name,
        'courseCode': student.courseCode,
        'courseName': student.courseName,
        'department': student.department,
        'section': student.section,
        'room': student.room,
        'bench': student.bench,
      });
    });
    await prefs.setString('student_cache', json.encode(map));
  }

  Future<Map<String, Student>> _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('student_cache');
    if (cached == null) return {};
    
    final map = json.decode(cached) as Map<String, dynamic>;
    final result = <String, Student>{};
    
    map.forEach((key, value) {
      final data = json.decode(value);
      result[key] = Student(
        id: data['id'],
        name: data['name'],
        courseCode: data['courseCode'],
        courseName: data['courseName'],
        department: data['department'],
        section: data['section'],
        room: data['room'],
        bench: data['bench'],
      );
    });
    
    return result;
  }
}