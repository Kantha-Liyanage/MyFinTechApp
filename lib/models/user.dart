import 'package:shared_preferences/shared_preferences.dart';

class User {
  String firstName;
  String lastName;
  String accessToken;

  User(this.firstName, this.lastName, this.accessToken);

  static Future<User> getFromLocalStorage() async {
    User user = User('', '', '');
    try {
      final prefs = await SharedPreferences.getInstance();
      user.firstName = prefs.getString('firstName')!;
      user.lastName = prefs.getString('lastName')!;
      user.accessToken = prefs.getString('accessToken')!;
    } catch (e) {}
    return user;
  }

  Future<void> saveToFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', firstName);
    prefs.setString('lastName', lastName);
    prefs.setString('accessToken', accessToken);
  }

  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getString('accessToken')!;
    } catch (e) {
      return "";
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getString('accessToken')!.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('accessToken', '');
  }
}
