import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static saveUserData(user) async {
    String userData = jsonEncode(user);
    await _preferences?.setString("userData", userData);
    // print('successful');
  }

  static getUserData() {
    _preferences?.getString("userData");
  }
}
