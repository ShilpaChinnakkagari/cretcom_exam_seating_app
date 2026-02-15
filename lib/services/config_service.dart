import 'package:firebase_database/firebase_database.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();

  String? _spreadsheetId;
  String? _apiKey;
  DateTime? _lastUpdated;

  String? get spreadsheetId => _spreadsheetId;
  String? get apiKey => _apiKey;
  DateTime? get lastUpdated => _lastUpdated;

  final DatabaseReference _configRef = 
      FirebaseDatabase.instance.ref().child('exam_config');

  Future<bool> loadConfig() async {
    try {
      final snapshot = await _configRef.get();
      
      if (snapshot.exists) {
        final data = snapshot.value as Map;
        _spreadsheetId = data['spreadsheetId']?.toString();
        _apiKey = data['apiKey']?.toString();
        
        print('✅ Config loaded from Firebase');
        print('📊 Sheet ID: $_spreadsheetId');
        return true;
      }
    } catch (e) {
      print('❌ Error loading config: $e');
    }
    
    // Fallback to hardcoded values
    print('⚠️ Using fallback config');
    _spreadsheetId = '1tPZ8Wim8Kony5JthYf9aVhxvDRLshP5Kv1-cdA_TiuE';
    _apiKey = 'AIzaSyBQS02d-enQ6ugCCKUgjyzt_PHt8Zwq6wo';
    return true;
  }
}