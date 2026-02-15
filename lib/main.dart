import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'services/config_service.dart';
import 'services/sheets_service.dart';
import 'models/student.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        Provider(create: (_) => ConfigService()),
      ],
      child: MaterialApp(
        title: 'CretCom Exam Seating',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  final SheetsService _service = SheetsService();
  bool _isLoading = false;
  bool _configLoading = true;
  String? _error;
  Student? _student;

  bool get isLoading => _isLoading;
  bool get configLoading => _configLoading;
  String? get error => _error;
  Student? get student => _student;

  AppState() {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    _configLoading = true;
    notifyListeners();
    
    final configService = ConfigService();
    await configService.loadConfig();
    
    _configLoading = false;
    notifyListeners();
  }

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