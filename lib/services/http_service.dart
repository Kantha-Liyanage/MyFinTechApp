import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_fintech_app/models/user.dart';

class HTTPSerivce {
  static const String apiBaseURL = 'http://10.0.2.2:3000/api/';
  static String accessToken = '';

  Future<Response> httpGet(String api) async {
    return await http.get(Uri.parse(apiBaseURL + api));
  }

  Future<Response> authenticatedHttpGet(String api) async {
    if (HTTPSerivce.accessToken.isEmpty) {
      accessToken = await User.getAccessToken();
    }

    var apiHeaders = {
      "authorization" : "Bearer " + accessToken
    };

    return await http.get(Uri.parse(apiBaseURL + api), headers: apiHeaders);
  }
}
