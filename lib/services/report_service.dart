import 'dart:convert';
import 'package:my_fintech_app/screens/transaction/bubbles/bar_chart_chat_bubble.dart';
import 'package:my_fintech_app/services/http_service.dart';

class ReportService extends HTTPSerivce {
  Future<Map<String, double>> fetchPieChartData(String report) async {
    final response = await authenticatedHttpGet('reports/' + report);

    if (response.statusCode == 200) {
      Map<String, String> rawData =
          Map<String, String>.from(jsonDecode(response.body));

      Map<String, double> data = <String, double>{};
      rawData.forEach((key, value) {
        data[key] = double.parse(value);
      });

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load report data.');
    }
  }

  Future<List<DataSeries>> fetchBarChartData(String report) async {
    final response = await authenticatedHttpGet('reports/' + report);

    if (response.statusCode == 200) {
      List<dynamic> dataRaw = jsonDecode(response.body);
      List<DataSeries> data = [];

      dataRaw.forEach((elementH) {
        List<DataPoint> items = [];
        List<dynamic> dataItemRaw = elementH['data'];
        dataItemRaw.forEach((elementI) {
          DataPoint point =
              DataPoint(elementI["name"], double.parse(elementI["amount"]));
          items.add(point);
        });

         DataSeries series = DataSeries(
          elementH['name'],
          items
        );

        data.add(series);
      });

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load report data.');
    }
  }
}
