import 'dart:convert';

import 'package:my_fintech_app/services/http_service.dart';

class ReportService extends HTTPSerivce {
  Future<Map<String, double>> fetch(String report) async {
    final response = await authenticatedHttpGet('reports/'+ report);

    if (response.statusCode == 200) {
      Map<String, double> data = jsonDecode(response.body);
      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load report data.');
    }
  }
}
