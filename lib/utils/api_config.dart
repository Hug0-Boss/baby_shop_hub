import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Set this when running against someone else's machine:
  //   flutter run --dart-define=API_URL=http://192.168.1.23:5162
  static const String _override = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    // Defaults: the Android emulator reaches your own PC at 10.0.2.2,
    // and the web build runs on the PC itself.
    return kIsWeb ? 'http://localhost:5162' : 'http://10.0.2.2:5162';
  }
}