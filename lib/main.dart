import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/sheets_service.dart';
import 'models/student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CretCom Exam Seating',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const HomeScreen(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  final SheetsService _service = SheetsService();
  bool _isLoading = false;
  String? _error;
  Student? _student;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Student? get student => _student;

  Future<void> searchStudent(String id) async {
    _isLoading = true;
    _error = null;
    _student = null;
    notifyListeners();

    try {
      final result = await _service.findStudentById(id);
      if (result != null) {
        _student = result;
      } else {
        _error = 'Student ID not found';
      }
    } catch (e) {
      _error = 'Network error. Check connection.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _student = null;
    _error = null;
    notifyListeners();
  }
}