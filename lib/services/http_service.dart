import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_fintech_app/models/user.dart';

class HTTPSerivce {
  //static const String apiBaseURL = 'http://10.0.2.2:3000/api/';
  static const String apiBaseURL = 'https://finapp-apis.azurewebsites.net/api/';
  static String accessToken = '';

  Future<Response> httpGet(String api) async {
    return await http.get(Uri.parse(apiBaseURL + api));
  }

  Future<Response> authenticatedHttpGet(String api) async {
    var headers = await _getHeaders();
    return await http.get(Uri.parse(apiBaseURL + api), headers: headers);
  }

  Future<Response> authenticatedHttpPost(String api, Object body) async {
    var headers = await _getHeaders();
    return await http.post(Uri.parse(apiBaseURL + api),
        headers: headers, body: body);
  }

  Future<Response> authenticatedHttpDelete(String api, Object body) async {
    var headers = await _getHeaders();
    return await http.delete(Uri.parse(apiBaseURL + api),
        headers: headers, body: body);
  }

  Future<Response> authenticatedHttpPatch(String api, Object body) async {
    var headers = await _getHeaders();
    return await http.patch(Uri.parse(apiBaseURL + api),
        headers: headers, body: body);
  }

  _getHeaders() async {
    if (HTTPSerivce.accessToken.isEmpty) {
      accessToken = await User.getAccessToken();
    }
    return {"authorization": "Bearer " + accessToken};
  }
}
