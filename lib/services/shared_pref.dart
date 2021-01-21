import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences preferences;

  /// use this to also set static preferences variable in global.dart
  static Future<SharedPreferences> getPrefs() async {
    preferences = await SharedPreferences.getInstance();
    return preferences;
  }
}
