import 'dart:convert';

import 'package:my_fintech_app/models/user.dart';
import 'package:my_fintech_app/services/http_service.dart';

class AuthService extends HTTPSerivce {
  Future<User> authenticate() async {
    final response = await httpGet('authentication');

    if (response.statusCode == 200) {
      var obj = jsonDecode(response.body);
      return User(obj['firstName'], obj['lastName'], obj['accessToken']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load accounts.');
    }
  }
}
